//
//  PopUpVC.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 17/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()
        self.removeAnimate()
    }

    func showAnimate() {
        self.view.backgroundColor = UIColor.clear
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.04)
        }
    }
   
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }

}
