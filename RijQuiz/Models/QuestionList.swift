//
//  QuestionList.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 19/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import Foundation

/*
 This struct is used to fetch all questions from an online server.
 The version in this QuestionList tells the app whether the questionslist has to be updated or not.
 */

struct QuestionList{
    var version : String
    var questions: [Question]
}
