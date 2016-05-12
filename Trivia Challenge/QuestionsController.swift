//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class QuestionsController: TemplateController {
    override var pageType: String { return "question" }
    var guessed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupButtons()
    }
    
    func setupButtons() {
        if (self.viewDictionary["restart_button"] != nil) {
            let restartButton : UIButton = self.viewDictionary["restart_button"] as! UIButton
            restartButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["answer_1"] != nil) {
            let answerButton1 : UIButton = self.viewDictionary["answer_1"] as! UIButton
            answerButton1.tag = 1
            answerButton1.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["answer_2"] != nil) {
            let answerButton2 : UIButton = self.viewDictionary["answer_2"] as! UIButton
            answerButton2.tag = 2
            answerButton2.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["answer_3"] != nil) {
            let answerButton3 : UIButton = self.viewDictionary["answer_3"] as! UIButton
            answerButton3.tag = 3
            answerButton3.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["answer_4"] != nil) {
            let answerButton4 : UIButton = self.viewDictionary["answer_4"] as! UIButton
            answerButton4.tag = 4
            answerButton4.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["answer_5"] != nil) {
            let answerButton5 : UIButton = self.viewDictionary["answer_5"] as! UIButton
            answerButton5.tag = 5
            answerButton5.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
    }
    
    func guess(button : UIButton) {
        if (self.guessed) {
            return
        }
        self.guessed = true
        
        let am = AssetManager.sharedInstance
        
        if (button.tag == am.gameState!.currentQuestion()!.correctAnswer) {
            am.gameState!.correctAnswers += 1
        } else {
            let toImage = self.placeholderImages["answer_incorrect"]!
            UIView.transitionWithView(button,
                                      duration: 0.3,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { button.setBackgroundImage(toImage, forState: .Normal) },
                                      completion: nil)
        }
        
        let answerTitle = "answer_\(am.gameState!.currentQuestion()!.correctAnswer)"
        let correctButton = self.viewDictionary[answerTitle] as! UIButton
        let toImage = self.placeholderImages["answer_correct"]
        UIView.transitionWithView(correctButton,
                                  duration: 0.3,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: { correctButton.setBackgroundImage(toImage, forState: .Normal) },
                                  completion: nil)

        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.2), target: self, selector: #selector(self.nextQuestion), userInfo: nil, repeats: false)
    }
    
    func nextQuestion() {
        let am = AssetManager.sharedInstance
        
        am.gameState!.questionIndex += 1
        if (am.gameState!.currentQuestion() != nil) {
            self.loadVC(QuestionsController())
        } else {
            self.loadVC(ResultsController())
        }
    }
}

