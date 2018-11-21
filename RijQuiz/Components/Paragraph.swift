//
//  Paragraph.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class Paragraph: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = UIFont(name: "Avenir-Light",
                      size: 20.0)
        layoutMargins.bottom = 15
    }

}
