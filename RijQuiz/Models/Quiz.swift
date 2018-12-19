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
    var timeLeftThisTurn : Int! = 15
    
    
    init (questions: [Question], currentSettings : Settings){
        self.questions = questions
        self.currentSettings = currentSettings
        if currentSettings.redo{
            attempts = 2
        }
        self.timeLeftThisTurn = currentSettings.secondsPerQuestion
    }
    
    mutating func nextAttempt(){
        attempts -= 1
    }
    
    func isThereAnotherQuestion() -> Bool{
        return ((currentQuestion + 1) != questions.count)
        
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
    
    mutating func calculateScore() -> (Int, Int){
        let amountOfQuestionsAnswered = currentQuestion
        var amountOfCorrectAnswers = 0
        
        for n in 0..<currentQuestion {
            if questions[n].checkIfAnswerCorrect() {
                amountOfCorrectAnswers += 1
            }
        }
        
        return (amountOfCorrectAnswers, amountOfQuestionsAnswered)
    }
    
    mutating func getAmountAnsweredQuestions() -> Int{
       return currentQuestion
    }
    
    mutating func timerTik(){
        timeLeftThisTurn -= 1
    }
    mutating func noTimeLeft() -> Bool {
        return timeLeftThisTurn == 0
    }
    mutating func resetTimer(){
        timeLeftThisTurn = currentSettings.secondsPerQuestion
    }
    
   
    
    
    
}
