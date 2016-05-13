//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/10/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class StartController: TemplateController {
    override var pageType: String { return "start" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupButtons()
    }
    
    func setupButtons() {
        let playTag = self.viewTags["play_button"]
        
        if (playTag != nil) {
            let playButton : UIButton = self.view.viewWithTag(playTag!) as! UIButton
            playButton.addTarget(self, action: #selector(self.loadQuestions), forControlEvents: .TouchUpInside)
        }
        
        let settingsTag = self.viewTags["settings_button"]
        
        if (settingsTag != nil) {
            let settingsButton : UIButton = self.view.viewWithTag(settingsTag!) as! UIButton
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

