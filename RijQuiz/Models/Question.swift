//
//  Question.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import Foundation

struct Question : Codable{
    
    var text : String
    var answers : [String]
    var rightAnswer : String
    var userAnswer : String?
    
    
    init(text : String, answers : [String], rightAnswer : String){
        self.text = text
        self.answers = answers
        self.rightAnswer = rightAnswer
    }
    
    func checkIfAnswerCorrect() -> Bool{
        return (userAnswer! == rightAnswer)                   
    }
}
