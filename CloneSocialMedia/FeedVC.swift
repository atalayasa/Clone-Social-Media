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
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    
    
    
    
    
    
    
    

    //Bu kısım sigouta tıkladığında Keychainden kaydedilmiş passwordü silip bi daha giriş yapman için.
    @IBAction func signOutBtnPressed(_ sender: Any) {
        if self.presentingViewController != nil {   //Mark ilk kurslarda söylemişti bir çok yeni developer bunu yapar diye eğer dismiss kullanmazsak ilerde patlar  //performSegue(withIdentifier: "goToSignIn", sender: nil) ile kullanırsak ekranlar çok birikiyor
            self.dismiss(animated: false, completion: nil)
        }
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID Removed from Keychain \(keychainResult)")
        try! Auth.auth().signOut()
    }

}
