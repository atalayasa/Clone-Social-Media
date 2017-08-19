//
//  PostCell.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 19/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
//Custom class olarak tableViewCelle ekle ve identifieri PostCell olarak tanımla***
    //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell sayesinde olur
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var userNameLbl:UILabel!
    @IBOutlet weak var postImg:UIImageView!
    @IBOutlet weak var caption:UITextView!
    @IBOutlet weak var likesLbl:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


}
