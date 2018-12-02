//
//  BottomBorderView.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 02/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class BottomBorderView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - 1.0, width:self.frame.size.width, height:1.0)
        self.layer.addSublayer(border)
    }

}
