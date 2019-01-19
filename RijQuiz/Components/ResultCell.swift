//
//  ResultCell.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 03/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var imgSucceeded: UIImageView!
    
    func setQuestion(questionNr : Int, answerCorrect : Bool){
        lblQuestion.text = "Vraag " + String(questionNr)
        if answerCorrect{
            lblQuestion.textColor = UIColor(rgbValue: 0x0f8736)
            imgSucceeded.image = UIImage(named: "check")
        } else {
            lblQuestion.textColor = UIColor.red
             imgSucceeded.image = UIImage(named: "error")
        }
    }
}
