//
//  ResultCell.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 03/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    @IBOutlet weak var btnQuestion: UIButton!
    
    var question : Question!
    
    @IBAction func btnQuestionTapped(_ sender: Any) {
        
    }
    
    func setQuestion(questionNr : Int, question : Question){
        self.question = question
        btnQuestion.setTitle(String(questionNr), for: .normal)
        if question.checkIfAnswerCorrect(){
        btnQuestion.setTitleColor(UIColor.green, for: .normal)
        } else {
        btnQuestion.setTitleColor(UIColor.red, for: .normal)
        }
    }
}
