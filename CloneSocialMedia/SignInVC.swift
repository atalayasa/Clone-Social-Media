//
//  SignInVC.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 15/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in    //SignInVC içinde istekte bulunduğuumz için self    //Facebook ile alakalı
            if error != nil {
                print("JESS! Unable to authenticate with Facebook \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("JESS! User cancelled Facebook authentication")
            } else {
                print("JESS! Successfully authenticated with Facebook") //
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
        
    }

    func firebaseAuthenticate(_ credential:AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in //Firebase auth sağlıyor. Firebase ile alakalı
            if error != nil {
                print("JESS! Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("JESS! Successfully authenticated with Firebase")
                
            }
        }
    }
}

