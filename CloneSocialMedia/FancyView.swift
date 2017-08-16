//
//  FancyView.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 16/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        
    }

}
