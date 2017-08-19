//
//  DataService.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 20/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()   //DBmizin rootunu içerir    //Google info plist içinde dbmizin url i olan https://clonesocialmedia.firebaseio.com/ zaten bulunuyor bu sayede erişebiliyoruz.

class DataService {
    //Singleton tanımlıyoruz db bağlantısı
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE //CloneSocialMedia DB'mizin en başındaki obje baseimiz
    private var _REF_POSTS = DB_BASE.child("posts") //CloneSocialMedia altındaki posts objesine erişir.
    private var _REF_USERS = DB_BASE.child("users") //CloneSocialMedia altındaki users objesine erişir.
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS : DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid : String, userData : Dictionary<String,String>) {
        REF_USERS.child(uid).updateChildValues(userData)    //usersın id kısmını pull ediyoruz. Herhangi bir şey döndürmesine gerek yok. Eğer bu değer yoksa dbye ekler.
    }
    
}
