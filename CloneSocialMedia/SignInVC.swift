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
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
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
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        //Bu fonksiyon eğer account yoksa oluşturur varsa direk devam eder.
        
        if (emailField.text?.characters.count != 0 || passwordField.text?.characters.count != 0) {
            print("Oldu")
            if let email = emailField.text, let password = passwordField.text {
               Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in  //Gidip firebase'den kontrol edecek //Firebase de email sign in auth method enable olması lazım.
                if error == nil {
                    print("JESS: Email User authenticate with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            print("JESS: Successfully authenticate with Firebase")
                        }
                    })
                }
               })
            }
        } else {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpVC
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
        
        
        
        
    }
}

