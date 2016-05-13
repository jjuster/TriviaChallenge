//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZLoadingActivity

class SettingsController: TemplateController {
    override var pageType: String { return "settings" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupButtons()
    }
    
    func setupButtons() {
        let loadTag = self.viewTags["load_button"]
        
        if (loadTag != nil) {
            let loadButton : UIButton = self.view.viewWithTag(loadTag!) as! UIButton
            loadButton.addTarget(self, action: #selector(self.loadGame), forControlEvents: .TouchUpInside)
        }
        
        let cancelTag = self.viewTags["cancel_button"]
        
        if (cancelTag != nil) {
            let cancelButton : UIButton = self.view.viewWithTag(cancelTag!) as! UIButton
            cancelButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }
    }
    
    func loadGame() {
        self.view.endEditing(true)
        
        let codeTag = self.viewTags["code_input"]
        
        if (codeTag == nil) {
            print("ERROR", "NO CODE INPUT")
            return
        }
        let codeInput : UITextField = self.view.viewWithTag(codeTag!) as! UITextField
        
        EZLoadingActivity.Settings.SuccessText = "Game Loaded"
        EZLoadingActivity.show("Loading Game", disableUI: true)
        
        AssetManager.sharedInstance.load(codeInput.text!, success: { (game : JSON) in
            print("LOADED!")
            AssetManager.sharedInstance.saveGame(game, success: {
                    EZLoadingActivity.hide(success: true, animated: true)
                
                    dispatch_async(dispatch_get_main_queue()) {
                        self.restart()                        
                    }
                }, failure: { (error) in
                    EZLoadingActivity.Settings.FailText = "Save Failed"
                    EZLoadingActivity.hide(success: false, animated: true)
            })
        }, failure: { (error) in
            print("ERROR", error)
            
            if (error == .InvalidCode) {
                EZLoadingActivity.Settings.FailText = "Invalid Code"
            } else {
                EZLoadingActivity.Settings.FailText = "Load Failed"
            }
            EZLoadingActivity.hide(success: false, animated: true)
        })
    }
}

