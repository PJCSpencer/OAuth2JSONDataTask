//
//  sdmTaskServices.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 17/08/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


protocol TaskCallbackDelegate
{
    associatedtype ArgType
    
    typealias ClosureType = (ArgType?, Error?) -> Void
    
    func sessionService(_ service: SessionService,
                        willRequest request: URLRequest?,
                        handlersForCallback callback: @escaping ClosureType) -> [Int:DataResponseClosure]
}


class DataService: SessionService /* TODO:Support URLSessionReceipt ... */
{
    // MARK: - Returning a Task
    
	func task(request: URLRequest,
	          handlers: [Int:DataResponseClosure],
	          fail: @escaping DataResponseClosure) -> URLSessionTask
	{ print("\(self)::\(#function), \(request)")
		
		let task: URLSessionDataTask = self.session.dataTask(with: request)
		{ (data, response, error) in
			
			print("response:\(response as Any), error:\(error as Any)\n")
			
			guard error == nil,
				let response = response as? HTTPURLResponse,
				let closure = handlers[response.statusCode] else
			{
                fail(nil, error)
				return
			}
			closure(data, nil)
		}
        
		return task
	}
}


class DownloadService: SessionService { /* TODO: */ }

