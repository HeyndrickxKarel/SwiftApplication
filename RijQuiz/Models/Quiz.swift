//
//  CurrentQuiz.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import Foundation

struct Quiz : Codable{
    
    var questions : [Question]
    var currentQuestion : Int = 0
    var currentSettings : Settings
    
    init (questions: [Question], currentSettings : Settings){
        self.questions = questions
        self.currentSettings = currentSettings
    }
    
    mutating func answerQuestion(answer: String){
        questions[currentQuestion].userAswer = answer
    }
}
