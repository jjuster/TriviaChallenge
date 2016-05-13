//
//  Question.swift
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import Foundation

class Question : NSObject {
    var questionId : Int?
    var question : String?
    var answer_1 : String?
    var answer_2 : String?
    var answer_3 : String?
    var answer_4 : String?
    var answer_5 : String?
    var correctAnswer : Int = 1
}