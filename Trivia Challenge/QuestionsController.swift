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
        let restartTag = self.viewTags["restart_button"]
        if (restartTag != nil) {
            let restartButton : UIButton = self.view.viewWithTag(restartTag!) as! UIButton
            restartButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }

        let answerTag1 = self.viewTags["answer_1"]
        if (answerTag1 != nil) {
            let answerButton1 : UIButton = self.view.viewWithTag(answerTag1!) as! UIButton
            answerButton1.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }

        let answerTag2 = self.viewTags["answer_2"]
        if (answerTag2 != nil) {
            let answerButton2 : UIButton = self.view.viewWithTag(answerTag2!) as! UIButton
            answerButton2.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }

        let answerTag3 = self.viewTags["answer_3"]
        if (answerTag3 != nil) {
            let answerButton3 : UIButton = self.view.viewWithTag(answerTag3!) as! UIButton
            answerButton3.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }

        let answerTag4 = self.viewTags["answer_4"]
        if (answerTag4 != nil) {
            let answerButton4 : UIButton = self.view.viewWithTag(answerTag4!) as! UIButton
            answerButton4.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }

        let answerTag5 = self.viewTags["answer_5"]
        if (answerTag5 != nil) {
            let answerButton5 : UIButton = self.view.viewWithTag(answerTag5!) as! UIButton
            answerButton5.addTarget(self, action: #selector(self.guess), forControlEvents: .TouchUpInside)
        }
    }
    
    func guess(button : UIButton) {
        if (self.guessed) {
            return
        }
        self.guessed = true
        
        let am = AssetManager.sharedInstance
        
        let correctTitle = "answer_\(am.gameState!.currentQuestion()!.correctAnswer)"
        let correctTag = self.viewTags[correctTitle]
        let correctButton : UIButton = self.view.viewWithTag(correctTag!) as! UIButton
        
        if (button == correctButton) {
            am.gameState!.correctAnswers += 1
        } else {
            let toImage = self.placeholderImages["answer_incorrect"]!
            UIView.transitionWithView(button,
                                      duration: 0.3,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { button.setBackgroundImage(toImage, forState: .Normal) },
                                      completion: nil)
        }
        
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

