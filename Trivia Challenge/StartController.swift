//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/10/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class StartController: TemplateController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.pageType = "start"
        
        self.loadBackgroundColor()
        self.loadImages()
        self.loadInputs()
        self.loadButtons()
        self.loadText()
        
        self.setupButtons()
    }
    
    func setupButtons() {
        if (self.viewDictionary["play_button"] != nil) {
            let settingsButton : UIButton = self.viewDictionary["play_button"] as! UIButton
            settingsButton.addTarget(self, action: #selector(self.loadQuestions), forControlEvents: .TouchUpInside)
        }

        if (self.viewDictionary["settings_button"] != nil) {
            let settingsButton : UIButton = self.viewDictionary["settings_button"] as! UIButton
            settingsButton.addTarget(self, action: #selector(self.loadSettings), forControlEvents: .TouchUpInside)
        }
    }

    func loadQuestions() {
        self.loadVC(QuestionsController())
    }
    
    func loadSettings() {
        self.loadVC(SettingsController())
    }
}

