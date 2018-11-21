//
//  PersonalSettings.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 19/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import Foundation

struct Settings : Codable{
    
    var secondsPerQuestion : Int
    var amountOfQuestions : Int
    var showAnswer : Bool
    var redo: Bool
    var saveQuiz : Bool
    
    init(secondsPerQuestion : Int, amountOfQuestions : Int, showAnswer : Bool, redo: Bool, saveQuiz : Bool) {
        self.secondsPerQuestion = secondsPerQuestion
        self.amountOfQuestions = amountOfQuestions
        self.showAnswer = showAnswer
        self.redo = redo
        self.saveQuiz = saveQuiz
    }
}
