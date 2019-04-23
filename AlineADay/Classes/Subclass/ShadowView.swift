//
//  ShadowView.swift
//  Finaureus
//
//  Created by developer on 20/02/19.
//  Copyright © 2019 Finaureus. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
      
    }
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
    
   

}
