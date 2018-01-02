//
//  sdmBasicController.swift
//  OAuth2JSONDataTask
//
//  Created by Peter Spencer on 29/12/2017.
//  Copyright © 2017 Peter Spencer. All rights reserved.
//

import UIKit


class BasicController: UIViewController
{
    // MARK: - Property(s)
    
    private(set) var user: UserAccess = UserAccess()
    
    
    // MARK: - Managing the View (UIViewController)
    
    override func loadView()
    { print("\(self)::\(#function)")
        
        self.view = UIView(frame: UIScreen.main.bounds)
    }
    
    
    // MARK: - Responding to View Events (UIViewController)
    
    override func viewDidAppear(_ animated: Bool)
    { print("\(self)::\(#function)")
        
        do
        {
            try self.user.oauth2.isAuthorised(toAccessPath: APIConfig.Path.APIRoot)
            { [weak self] (result) in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async
                {
                    if result ==  true
                    {
                        strongSelf.records()
                    }
                    else
                    {
                        strongSelf.login()
                    }
                }
            }
        }
        catch
        {
            self.login()
        }
    }
    
    
    // MARK: - Login Utility
    
    func login()
    { print("\(self)::\(#function)")
        
        do
        {
            try self.user.oauth2.grantAccess()
            { [weak self] (tokens, error) in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async { strongSelf.records() }
            }
        }
        catch { /* TODO: */ }
    }
    
    
    // MARK: - Data Access
    
    func records(/* TODO:Support completion callback ... */)
    { print("\(self)::\(#function)")
        
        do
        {
            try self.user.json.request(resourceAtPath: APIConfig.Path.APIDemo)
            { (data, error) in
                
                guard error == nil,
                    let data = data else
                {
                    print("\(self)::\(#function) > FAILED")
                    return
                }
                print("Response data:\(data)")
            }
        }
        catch { /* TODO: */ }
    }
}

