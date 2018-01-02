//
//  sdmOAuth2Access.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 19/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


enum OAuth2Error: Error
{
    case requestOrIdentity
    case requestOrToken
    case serialize
    case unauthorised
}

protocol OAuth2IdentityDelegate
{
    func username() -> String?
    
    func password() -> String?
}

protocol OAuth2ReadWriteDelegate
{
    func token(forKey key: String) -> String?
    
    func setToken(_ value: String, forKey key: String)
}

struct OAuth2Tokens
{
    let access: String
    let refresh: String
}

typealias OAuth2ResponseClosure = (OAuth2Tokens?, Error?) -> Void


class OAuth2Access: DataService, TaskCallbackDelegate
{
    // MARK: - Credentials
    
    static let kClientId: String = ""
    
    static let kClientSecret: String = ""
    
    
    // MARK: - Constant(s)
    
    struct Key
    {
        static let ClientId: String         = "client_id"
        static let ClientSecret: String     = "client_secret"
        
        static let Username: String         = "username"
        static let Password: String         = "password"
        static let GrantType: String        = "grant_type"
        static let AccessToken: String      = "access_token"
        static let RefreshToken: String     = "refresh_token"
        
        static let Bearer: String           = "Bearer"
        static let Authorization: String    = "Authorization"
    }
    
    
    // MARK: - Property(s)
    
    final var identityDelegate: OAuth2IdentityDelegate?
    
    final var tokenDelegate: OAuth2ReadWriteDelegate?
    
    
    // MARK: - General Purpose Request(s)
    
    private func requestTokens(request: URLRequest,
                               callback: @escaping OAuth2ResponseClosure)
    { print("\(self)::\(#function)")
        
        let handlers = self.sessionService(self,
                                           willRequest: nil,
                                           handlersForCallback: callback)
        
        self.task(request: request,
                  handlers: handlers,
                  fail: { _,_ in callback(nil, OAuth2Error.unauthorised) }).resume()
    }
    
    
    // MARK: - Convienience
    
    func grantAccess(callback: @escaping OAuth2ResponseClosure) throws
    { print("\(self)::\(#function)")
        
        guard let username = self.identityDelegate?.username(),
            let password = self.identityDelegate?.password(),
            let request = URLRequest.grant(username: username,
                                           password: password) else
        {
            throw OAuth2Error.requestOrIdentity
        }
        
        self.requestTokens(request: request,
                           callback: callback)
    }
    
    func refreshAccess(callback: @escaping OAuth2ResponseClosure) throws
    { print("\(self)::\(#function)")
        
        guard let token = self.tokenDelegate?.token(forKey: OAuth2Access.Key.RefreshToken),
            let request = URLRequest.refresh(with: token) else
        {
            throw OAuth2Error.requestOrToken
        }
        
        self.requestTokens(request: request,
                           callback: callback)
    }
    
    
    // MARK: - Utility
    
    func isAuthorised(toAccessPath path: String,
                      callback: @escaping (Bool) -> Void) throws
    { print("\(self)::\(#function)")
        
        guard let token = self.tokenDelegate?.token(forKey: OAuth2Access.Key.AccessToken),
            let request = URLRequest.bearer(path: path,
                                            token: token) else
        {
            throw OAuth2Error.requestOrToken
        }
        
        let handler: DataResponseClosure = { _,_ in callback(true) }
        
        self.task(request: request,
                  handlers: [200:handler],
                  fail: { _,_ in callback(false) }).resume()
    }
    
    
    // MARK: - TaskCallbackDelegate Protocol
    
    typealias ArgType = OAuth2Tokens
    
    func sessionService(_ service: SessionService,
                        willRequest request: URLRequest?,
                        handlersForCallback callback: @escaping ClosureType) -> [Int:DataResponseClosure]
    { print("\(service)::\(#function)")
        
        guard let castedService = service as? OAuth2Access else
        {
            return [:]
        }
        
        let handler: DataResponseClosure =
        { (data, error) in
            
            guard error == nil,
                let data = data,
                let json = try? JSONSerialization.object(data: data), /* TODO:Refactor ..? */
                let accessToken = json[OAuth2Access.Key.AccessToken] as? String,
                let refreshToken = json[OAuth2Access.Key.RefreshToken] as? String else
            {
                callback(nil, OAuth2Error.serialize)
                return
            }
            
            castedService.tokenDelegate?.setToken(accessToken,
                                                  forKey: OAuth2Access.Key.AccessToken)
            
            castedService.tokenDelegate?.setToken(refreshToken,
                                                  forKey: OAuth2Access.Key.RefreshToken)
            
            callback(nil, nil)
        }
        
        return [200:handler]
    }
}

