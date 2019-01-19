//
//  RoundedAnswerButton.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 19/01/2019.
//  Copyright © 2019 Karel Heyndrickx. All rights reserved.
//

import UIKit

class RoundedAnswerButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 9
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        self.setTitleColor(UIColor.white,for: .normal)
        layer.backgroundColor = (UIColor(rgbValue: 0x56adef, alpha: 1.0)).cgColor

    }
    
}
