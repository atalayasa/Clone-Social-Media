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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    @IBOutlet weak var captionField: FancyTextField!
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    
    static var imageCache: NSCache<NSString,UIImage> = NSCache()    //Postlara cache eklemek için
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in  //DBdeki Posts objesinde olacak herhangi bir değişikliği izliyoruz.
        self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] { //Posts objesinin tüm elemanlarını çekiyoruz yani tüm data.
               // print("SNAP: \(snapshot)")
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String,AnyObject> { //Snap yalnızca 1 obje (likes,caption ve idsi bulunan) her seferde biriyle işimiz yapıyoruz.
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        } else {
            return PostCell()
        }
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {   //Imageın gerçekten seçilip seçilmediğini kontrol ediyoruz. Info fonksiyonun infosu
            imageAdd.image = image
            imageSelected = true
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("JESS: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)    //Resim seçilince ekranın kapanması için
    }
    
    @IBAction func addImageBtnPressed(_ sender: Any) {  //TapGesture ekledik buraya tap gesture eklediğinde main.storyboarddan user interaction enabled yapman gerekiyor.
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionField.text , caption != "" else {    //Guard if let yerine kullanılabilecek kodu güzelleştirmek adına koyulmuş bir yapı böyle bir yapı olup olmadığını kontrol ediyor.
            print("JESS: Caption must be entered")
            return
        }
        guard let img = imageAdd.image , imageSelected == true else {
            print("JESS: An image must be selected")
            return
        }
        //İlk olarak resmi compress ediyoruz. Ardından spesifik bir uid belirliyoruz. Metadatasında resim olduğunu ve tipini gönderiyoruz.
        //Put fonksiyonu resmi verdiğimiz linkteki yere upload ediyor ve biz bir downloadURL e sahip oluyoruz. Uygulamaya tekrar girilince oradan çekmesi için
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString    //Her bir resim için Unique bir uid yaratır.
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("JESS: Unable to upload image to Firebase Storage")
                } else {
                    print("JESS: Successfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString   //İlerleyen videolarda kullanılacak resmin indirilme URL i olarak
                }
            })
        }
    }
    
    
    
    
    
    

}
