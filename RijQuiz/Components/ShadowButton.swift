//
//  BorderWhiteButton.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 3
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
                
    }

}
