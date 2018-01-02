//
//  sdmUserAccess.swift
//  OAuth2JSONDataTask
//
//  Created by Peter JC Spencer on 25/06/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


class UserAccess: KeychainAccess, OAuth2IdentityDelegate, OAuth2ReadWriteDelegate
{
	// MARK: - Lazy Property(s)
	
	final private(set) lazy var oauth2: OAuth2Access =
	{ [unowned self] in
		
		let anObject = OAuth2Access()
        anObject.identityDelegate = self
		anObject.tokenDelegate = self
        
		return anObject
	}()
	
	final private(set) lazy var json: JSONAccessProtected =
	{ [unowned self] in
		
		let anObject = JSONAccessProtected()
		anObject.oauth2 = self.oauth2
		
		return anObject
	}()
	
	
    // MARK: - OAuth2IdentityDelegate Protocol
    
    func username() -> String? /* TODO: */
    {
        return nil
    }
    
    func password() -> String?
    {
        return nil
    }
    
    
	// MARK: - OAuth2ReadWriteDelegate Protocol
	
	func token(forKey key: String) -> String? 
	{ print("\(self)::\(#function)")
        
        return KeychainAccess.string(forKey:key)
	}
	
	func setToken(_ value: String, forKey key: String)
    { print("\(self)::\(#function) > key:\(key), value:\(value)")
        
		KeychainAccess.setString(value, forKey: key)
	}
}

