//
//  Header.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class Header: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = UIFont(name: "Avenir-Heavy",
                      size: 40.0)
        layoutMargins.bottom = 30
    }

}
