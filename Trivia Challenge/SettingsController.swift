//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsController: TemplateController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageType = "settings"
        
        self.loadBackgroundColor()
        self.loadImages()
        self.loadInputs()
        self.loadButtons()
        self.loadText()
        
        self.setupButtons()
    }
    
    func setupButtons() {
        if (self.viewDictionary["load_button"] != nil) {
            let loadButton : UIButton = self.viewDictionary["load_button"] as! UIButton
            loadButton.addTarget(self, action: #selector(self.loadGame), forControlEvents: .TouchUpInside)
        }
        
        if (self.viewDictionary["cancel_button"] != nil) {
            let loadButton : UIButton = self.viewDictionary["cancel_button"] as! UIButton
            loadButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }
    }
    
    func loadGame() {
        if (self.viewDictionary["code_input"] == nil) {
            print("ERROR", "NO CODE INPUT")
            return
        }
        
        let codeInput : UITextField = self.viewDictionary["code_input"] as! UITextField
        
        AssetManager.sharedInstance.load(codeInput.text!, success: { (game : JSON) in
            print("LOADED!")
            AssetManager.sharedInstance.saveGame(game, success: {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.restart()
                    }
                }, failure: { (error) in
            })
        }, failure: { (error) in
            print("ERROR", error)
            
            if (error == .InvalidCode) {
                let alertController = UIAlertController(title: "Invalid Game Code", message: "Please try a new code (e.g. SPONSOR1)", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    alertController.dismissViewControllerAnimated(false, completion: nil)
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
}

