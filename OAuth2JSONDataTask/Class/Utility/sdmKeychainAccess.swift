//
//  sdmKeychainAccess.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 18/05/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


class KeychainAccess /* TODO:Support keychain read/write ... */
{
    static func string(forKey key: String) -> String?
    { print("\(self)::\(#function)")
        
        guard let str = UserDefaults.standard.value(forKey: key) as? String else
        {
            return nil
        }
        return str
    }
    
    static func setString(_ value: String, forKey key: String)
    { print("\(self)::\(#function) > key:\(key), value:\(value)")
        
        let defaults: UserDefaults = UserDefaults.standard
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
}

