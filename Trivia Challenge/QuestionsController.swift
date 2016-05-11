//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class QuestionsController: TemplateController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.pageType = "question"
        
        self.loadBackgroundColor()
        self.loadImages()
        self.loadInputs()
        self.loadButtons()
        self.loadText()
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
        let am = AssetManager.sharedInstance
        if (button.tag == am.gameState!.currentQuestion()!.correctAnswer) {
            am.gameState!.correctAnswers += 1
        }
        am.gameState!.questionIndex += 1
        
        if (am.gameState!.currentQuestion() != nil) {
            self.loadVC(QuestionsController())
        } else {
            self.loadVC(ResultsController())
        }
    }
}

