//
//  PostCell.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 19/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
//Custom class olarak tableViewCelle ekle ve identifieri PostCell olarak tanımla***
    //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell sayesinde olur
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var userNameLbl:UILabel!
    @IBOutlet weak var postImg:UIImageView!
    @IBOutlet weak var caption:UITextView!
    @IBOutlet weak var likesLbl:UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    
    var likesRef:DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post

        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil { //Eğer cache 'de image varsa direk onu alıyoruz. Else storageımıza onu ekliyoruz.
            self.postImg.image = img
        } else {
                let ref = Storage.storage().reference(forURL: post.imageUrl)

                ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in    //Yüklenebilecek datanın maksimum boyutu.
                    if error != nil {
                        print("JESS: Unable to download image from Firebase Storage")
                    } else {
                        print("JESS: Image downloaded from Firebase Storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey:post.imageUrl as NSString)
                            }
                        }
                    }
                })
            
            
            
            }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in   //Beğenip beğenmem butonunu işlevini yüklüyoruz.
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")  //Daha hiç tıklanmamışken boş kalp ama tıklanırsa dolu
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in   //Beğenip beğenmem butonunu işlevini yüklüyoruz.
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")         //Yukarıdakinden farkı burada tıklanmış kalp şu an kırmızı
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)    //DBden true yapıyoruz user tableından
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
        
    }


