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
        
//        self.emailField.delegate = self     //Bu iki satır bir yere dokunduğunda klavyenin kaybolması için
//        self.passwordField.delegate = self
//        
        
        //Tıklayınca klavyenin çıkması
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)

        showInitialViewWhenPressedOnScreen()
        
    }

    //yukarıda self.email field ile aynı işi yapıyor.
    func showInitialViewWhenPressedOnScreen() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
        
        if (emailField.text?.characters.count != 0 && passwordField.text?.characters.count != 0) {
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
        } else {    //Kullanıcının boş password veya email girmesi durumunda
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpVC
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
 
    }
    
    //Buradan
    func keyboardWillShow(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= kbSize.height
            }
            
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += kbSize.height
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
    //Buraya kadar olan kısım klavyenin gösterilip aşağı kaydırılmasıyla alakalı
    

    
    
}

