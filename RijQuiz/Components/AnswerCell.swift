//
//  AnswerCell.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {

    @IBOutlet weak var lblAnswer: UILabel!
    
    func setAnswer(answer :String){
        lblAnswer.text = answer
    }
}
