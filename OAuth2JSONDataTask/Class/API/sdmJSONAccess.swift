//
//  sdmJSONAccess.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 03/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


struct JSONResponse
{
    let code: Int
    let data: [JSONObject]
}

typealias JSONResponseClosure = ([JSONObject]?, Error?) -> Void


class JSONAccess: DataService, TaskCallbackDelegate
{
    // MARK: - General Purpose Request(s)
	
	func request(resourceAtPath path: String,
                 params: [String:String] = [:],
	             callback: @escaping JSONResponseClosure) throws
	{ print("\(self)::\(#function)")
		
		guard let request = URLRequest.objects(path: path,
			                                 params: params,
			                                 token: nil) else
		{
			throw AccessError.request
		}
		
        let handlers = self.sessionService(self,
                                           willRequest: request,
                                           handlersForCallback: callback)
        
        self.task(request: request,
                  handlers: handlers,
                  fail: { _,_ in callback(nil, AccessError.failed) }).resume()
	}
    
    
    // MARK: - TaskCallbackDelegate Protocol
    
    typealias ArgType = [JSONObject]
    
    func sessionService(_ service: SessionService,
                        willRequest request: URLRequest?,
                        handlersForCallback callback: @escaping ClosureType) -> [Int:DataResponseClosure]
    { print("\(self)::\(#function)")
        
        let handler: DataResponseClosure =
        { (data, error) in
            
            guard let data = data,
                let json = try? JSONSerialization.collection(data: data) else
            {
                callback(nil, AccessError.serialize)
                return
            }
            callback(json, nil)
        }
        
        return [200:handler]
    }
}

