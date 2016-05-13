//
//  Game.swift
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import Foundation

class Game : NSObject {
    var randomizeQuestions : Bool = true
    var randomizeAnswers : Bool = true
    var numberQuestions : Int?
    
    var lowScoreMessage : String?
    var mediumScoreMessage : String?
    var highScoreMessage : String?
    var perfectScoreMessage : String?
    
    var questionIndex : Int = 0
    var correctAnswers : Int = 0
    
    var questions : [Question] = [Question]()
    
    func getProp(prop: String) -> String? {
        switch(prop) {
            case "[questionIds]":
                return self.questionIds()
            case "[questionId]":
                return String(self.currentQuestion()!.questionId!)
            case "[numCorrect]":
                return String(correctAnswers)
            case "[questionNumber]":
                return String(questionIndex + 1)
            case "[questionCount]":
                return String(numberQuestions!)
            case "[question]":
                return self.currentQuestion()!.question
            case "[answer_1]":
                return self.currentQuestion()!.answer_1
            case "[answer_2]":
                return self.currentQuestion()!.answer_2
            case "[answer_3]":
                return self.currentQuestion()!.answer_3
            case "[answer_4]":
                return self.currentQuestion()!.answer_4
            case "[answer_5]":
                return self.currentQuestion()!.answer_5
            case "[feedbackMessage]":
                return self.feedbackMessage()
            default:
                return nil
        }
    }
    
    func currentQuestion() -> Question? {
        if (questionIndex >= questions.count) {
            return nil
        } else {
            return questions[questionIndex]
        }
    }
    
    func questionIds() -> String {
        var questionIds = ""
        for (i, question) in self.questions.enumerate() {
            questionIds += "\(question.questionId!)"
            if (i < self.questions.count - 1) {
                questionIds += ", "
            }
        }
        
        return questionIds
    }
    
    func feedbackMessage() -> String {
        let score = Float(self.correctAnswers) / Float(self.numberQuestions!)
        
        if (score < 0.4) {
            return self.lowScoreMessage!
        } else if (score < 0.75) {
            return self.mediumScoreMessage!
        } else if (score == 1.0) {
            return self.perfectScoreMessage!
        } else {
            return self.highScoreMessage!
        }
    }
    
    override init() {
        super.init()
        
        self.questionIndex = 0
        self.correctAnswers = 0
    }
}