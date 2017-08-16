//
//  RoundFacebookBtn.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 16/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class RoundFacebookBtn: UIButton {  //Facebook butonu için yapıyoruz.

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imageView?.contentMode = .scaleAspectFit
        //bu haliyle de doğru ama viewın lifecylce olayıyla alakalı bir durum alttaki daha iyi subviewın yüklendiği anda widthin yarısına böl diyorsun.  layer.cornerRadius = 75
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
    
    
}
