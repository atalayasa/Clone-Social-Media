//
//  FancyTextField.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 16/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class FancyTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {    //TextField içindeki yazının x y ekseninde yukaru aşağı sağa sola olan konumunu değiştiriyor.
        return bounds.insetBy(dx: 10, dy: 5)
    }

    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
