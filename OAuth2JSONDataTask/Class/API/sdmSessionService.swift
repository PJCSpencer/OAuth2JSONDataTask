//
//  sdmSessionService.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 01/06/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


enum AccessError: Error
{
    case url
    case request
    case failed
    case serialize
}

struct URLSessionReceipt
{
    let identifier: Int
    let timestamp: Double
    let path: String
}

extension URLSessionReceipt: Hashable
{
    var hashValue: Int
    {
        return self.identifier
    }
    
    static func == (lhs: URLSessionReceipt, rhs: URLSessionReceipt) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}

typealias ErrorClosure = (Error) -> Void

typealias DataResponseClosure = (Data?, Error?) -> Void

typealias AnyResponseClosure = (Any?, Error?) -> Void


class SessionService /* TODO:Support reciept(s) caching protocol ... */
{
    // MARK: - Constant(s)
    
    static let diskPath: String = "com.your-company.app-name.url-cache"
    
    
    // MARK: - Interval(s)
    
    static let defaultTimeoutInterval: TimeInterval = 30.0
    
    
    // MARK: - Lazy Property(s)
    
    private(set) lazy var sessionConfiguration: URLSessionConfiguration =
    { [unowned self] in
            
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.timeoutIntervalForRequest = SessionService.defaultTimeoutInterval
        anObject.allowsCellularAccess = false
        anObject.urlCache = URLCache(memoryCapacity: 20.megabytes(),
                                     diskCapacity: 100.megabytes(),
                                     diskPath: SessionService.diskPath)
        
        return anObject
    }()
    
    final private(set) lazy var session: URLSession =
    { [unowned self] in
        
        let anObject: URLSession = URLSession(configuration: self.sessionConfiguration,
                                              delegate: nil,
                                              delegateQueue: nil)
            
        return anObject
    }()
}

