//
//  sdmSerializationExtensions.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 19/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


enum JSONSerializationError: Error
{
    case failed
}

typealias JSONObject = [String:Any]


extension JSONSerialization
{
    static func collection(data: Data) throws -> [JSONObject]
    {
        do
        {
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: []) as? [JSONObject] ?? []
            return json
        }
        catch _ { throw JSONSerializationError.failed }
    }
    
    static func object(data: Data) throws -> JSONObject /* TODO:Support optional, required keys arg ... */
    {
        do
        {
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: []) as? JSONObject ?? [:]
            return json
        }
        catch _ { throw JSONSerializationError.failed }
    }
}

