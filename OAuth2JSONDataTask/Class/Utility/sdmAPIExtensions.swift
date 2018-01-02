//
//  sdmAPIExtensions.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 14/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


extension URLComponents
{
    static func base(path: String) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = APIConfig.Scheme
        components.host = APIConfig.Host.Default
        components.port = APIConfig.Port.Default
        components.path = path
        
        return components
    }
}


extension URLRequest
{
    // MARK: - Key Constant(s)
    
    struct Key
    {
        static let ContentType: String  = "Content-Type"
    }
    
    
    // MARK: - General Purpose Endpoint(s)
    
    static func objects(path: String,
                        params: [String:String],
                        token: String? = nil) -> URLRequest?
    {
        var components: URLComponents = URLComponents.base(path: path)
        
        if params.count > 0
        {
            var queryItems: [URLQueryItem] = []
            for (key, value) in params
            {
                queryItems.append( URLQueryItem(name: key, value: value) )
            }
            components.queryItems = queryItems
        }
        
        guard let url = components.url else
        {
            return nil
        }
        
        return URLRequest.with(url: url, token: token)
    }
    
    static func with(url: URL,
                     token: String? = nil) -> URLRequest
    {
        var request: URLRequest = URLRequest(url: url)
        request.timeoutInterval = SessionService.defaultTimeoutInterval
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = token else
        {
            return request
        }
        
        request.setValue("\(OAuth2Access.Key.Bearer) \(token)",
            forHTTPHeaderField: OAuth2Access.Key.Authorization)
        
        return request
    }
    
    
    // MARK: - OAuth2 Endpoint(s)
    
    static func grant(username: String,
                      password: String) -> URLRequest?
    {
        var components: URLComponents = URLComponents.base(path: APIConfig.Path.OAuth2Token)
        components.queryItems = [
            
            URLQueryItem(name: OAuth2Access.Key.GrantType, value: OAuth2Access.Key.Password),
            URLQueryItem(name: OAuth2Access.Key.Username, value: username),
            URLQueryItem(name: OAuth2Access.Key.Password, value: password),
            URLQueryItem(name: OAuth2Access.Key.ClientId, value: OAuth2Access.kClientId),
            URLQueryItem(name: OAuth2Access.Key.ClientSecret, value: OAuth2Access.kClientSecret)
        ]
        
        guard let url = components.url else
        {
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url,
                                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                             timeoutInterval: SessionService.defaultTimeoutInterval)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(ContentType.urlencoded.rawValue,
                         forHTTPHeaderField: URLRequest.Key.ContentType)
        
        return request
    }
    
    static func refresh(with token: String) -> URLRequest?
    {
        var components: URLComponents = URLComponents.base(path: APIConfig.Path.OAuth2Token)
        components.queryItems = [
            
            URLQueryItem(name: OAuth2Access.Key.GrantType, value: OAuth2Access.Key.RefreshToken),
            URLQueryItem(name: OAuth2Access.Key.RefreshToken, value: token),
            URLQueryItem(name: OAuth2Access.Key.ClientId, value: OAuth2Access.kClientId),
            URLQueryItem(name: OAuth2Access.Key.ClientSecret, value: OAuth2Access.kClientSecret)
        ]
        
        guard let url = components.url else
        {
            return nil
        }
        
        var request: URLRequest = URLRequest.with(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(ContentType.urlencoded.rawValue,
                         forHTTPHeaderField: URLRequest.Key.ContentType)
        
        return request
    }
    
    static func bearer(path: String,
                       token: String) -> URLRequest?
    {
        let components: URLComponents = URLComponents.base(path: path)
        
        guard let url = components.url else
        {
            return nil
        }
        
        return URLRequest.with(url: url, token: token)
    }
}

