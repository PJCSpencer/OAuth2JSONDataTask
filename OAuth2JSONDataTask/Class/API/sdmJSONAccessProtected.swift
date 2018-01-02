//
//  sdmJSONAccessProtected.swift
//  OAuth2JSONDataTask
//
//  Created by Peter Spencer on 29/12/2017.
//  Copyright © 2017 Peter Spencer. All rights reserved.
//

import Foundation


class JSONAccessProtected: JSONAccess
{
    // MARK: - Property(s)
    
    final var oauth2: OAuth2Access? /* TODO:Support delegate ..? */
    
    
    // MARK: - Override(s)
    
    override func request(resourceAtPath path: String,
                          params: [String:String] = [:],
                          callback: @escaping JSONResponseClosure) throws
    { print("\(self)::\(#function)")
        
        guard let token = self.oauth2?.tokenDelegate?.token(forKey: OAuth2Access.Key.AccessToken),
            let request = URLRequest.objects(path: path,
                                             params: params,
                                             token: token) else
        {
            throw OAuth2Error.requestOrToken
        }
        
        let handlers = self.sessionService(self,
                                           willRequest: request,
                                           handlersForCallback: callback)
        
        self.task(request: request,
                  handlers: handlers,
                  fail: { _,_ in callback(nil, AccessError.failed) }).resume()
    }
    
    
    // MARK: - TaskCallbackDelegate Protocol
    
    override func sessionService(_ service: SessionService,
                                 willRequest request: URLRequest?,
                                 handlersForCallback callback: @escaping ClosureType) -> [Int:DataResponseClosure]
    { print("\(self)::\(#function)")
        
        guard let castedService = service as? JSONAccessProtected,
            let request = request else
        {
            return [:]
        }
        
        let serialise: DataResponseClosure =
        { (data, error) in
            
            guard let data = data,
                let json = try? JSONSerialization.collection(data: data) else
            {
                callback(nil, AccessError.serialize)
                return
            }
            callback(json, nil)
        }
        
        let authorise: DataResponseClosure =
        { _,_ in
            
            do
            {
                try castedService.oauth2?.refreshAccess()
                { (tokens, error) in
                    
                    guard error == nil,
                        let token = castedService.oauth2?.tokenDelegate?.token(forKey: OAuth2Access.Key.AccessToken),
                        let url = request.url else
                    {
                        callback(nil, OAuth2Error.unauthorised)
                        return
                    }
                    
                    castedService.task(request: URLRequest.with(url: url, token: token),
                                       handlers: [200:serialise],
                                       fail: { _,_ in callback(nil, AccessError.failed) }).resume()
                }
            }
            catch { /* TODO: */ }
        }
        
        return [200:serialise, 401:authorise]
    }
}

