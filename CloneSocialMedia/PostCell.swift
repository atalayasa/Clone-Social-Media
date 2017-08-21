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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post

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
        }
        
    }


