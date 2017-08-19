//
//  FeedVC.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 19/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
//İkinci ekranın controlleri
class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Bu kısım sigouta tıkladığında Keychainden kaydedilmiş passwordü silip bi daha giriş yapman için.
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID Removed from Keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
