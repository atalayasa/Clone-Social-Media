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
import SwiftKeychainWrapper //Password Hatırlaması için her seferinde girişte sormaması için

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewDidLoad performsegue yapamaz. Çok erken yapması için
//        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            print("JESS: ID found in keychain")
//            performSegue(withIdentifier: "goToFeed", sender: nil)
//        }

        //Tıklayınca klavyenin çıkması
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)

        showInitialViewWhenPressedOnScreen()
    }
    //Segue has to be apperared viewDidAppear***    //User sign in için yapıldı.
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JESS: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
        Auth.auth().signIn(with: credential) { (user, error) in //Firebase auth sağlıyor. Firebase ile alakalı  //Facebook hesabıyla giriş için
            if error != nil {
                print("JESS! Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("JESS! Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                    //KeychainWrapper.standard.set(user.uid, forKey:KEY_UID) //user yukarıdaki completion handler da bulunan user
                }
                
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
                    
                    if let user = user {
                      self.completeSignIn(id: user.uid)  //Tek tek auto sign in kodu yazmak yerine fonksiyonun çağırıp aynı işi yapıyoruz.
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            print("JESS: Successfully authenticate with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
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
    //Burada ise kullanıcının hesabının açık olup olmadığını kontrol edip auto sign ini sağlıyoruz.
    func completeSignIn(id:String) {
       let keychainResult = KeychainWrapper.standard.set(id, forKey:KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
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
    
    //Ekranın bir yerine dokunduğunda klavyenin kaybolmasını sağlıyor
    func showInitialViewWhenPressedOnScreen() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
}

