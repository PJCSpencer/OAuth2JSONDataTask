//
//  sdmAPIConfig.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 19/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


enum HTTPScheme: String
{
    case http       = "http"
    case https      = "https"
}

enum HTTPMethod: String
{
    case options    = "OPTIONS"
    case get        = "GET"
    case post       = "POST"
}

enum ContentType: String
{
    case urlencoded = "application/x-www-form-urlencoded"
}


class APIConfig
{
    // MARK: - Path Constant(s)
    
    struct Path
    {
        static let APIRoot: String = "/api/"
        static let APIDemo: String = APIRoot + ""
        
        static let OAuth2Token: String = "/oauth2/token/"
    }
    
    
    // MARK: - Scheme Constant(s)
    
    static let Scheme: String = HTTPScheme.http.rawValue
    
    
    // MARK: - Host Constant(s)
    
    struct Host
    {
        static let Development: String = ""
        static let Production: String = ""
        static let Local: String = "127.0.0.1"
        
        static let Default: String = Development
    }
    
    
    // MARK: - Port Constant(s)
    
    struct Port
    {
        static let Default: Int = 8000
    }
}

