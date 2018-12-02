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
    var attempts : Int = 1
    
    
    init (questions: [Question], currentSettings : Settings){
        self.questions = questions
        self.currentSettings = currentSettings
        if currentSettings.redo{
            attempts = 2
        }
    }
    
    mutating func nextAttempt(){
        attempts -= 1
    }
    
    mutating func nextQuestion(){
        currentQuestion += 1
        attempts = 2
    }
    
    mutating func isAnswerCorrect() -> Bool {
        let answerCorrect = questions[currentQuestion].checkIfAnswerCorrect()
        return answerCorrect
    }
    mutating func answerQuestion(answer: String){
        questions[currentQuestion].userAnswer = answer
    }
    
    
   
    
    
    
}
