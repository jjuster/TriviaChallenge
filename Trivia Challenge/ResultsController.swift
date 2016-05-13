//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class ResultsController: TemplateController {
    override var pageType: String { return "results" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupButtons()
    }
    
    func setupButtons() {
        let startOverTag = self.viewTags["start_over_button"]
        
        if (startOverTag != nil) {
            let startOverButton : UIButton = self.view.viewWithTag(startOverTag!) as! UIButton
            startOverButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }
        
        let moreInfoTag = self.viewTags["more_info_button"]
        
        if (moreInfoTag != nil) {
            let moreInfoButton : UIButton = self.view.viewWithTag(moreInfoTag!) as! UIButton
            moreInfoButton.addTarget(self, action: #selector(self.showMoreInfo), forControlEvents: .TouchUpInside)
        }
    }
    
    func showMoreInfo() {
        let am = AssetManager.sharedInstance
        let alertController = UIAlertController(title: "Question IDs", message: am.gameState!.questionIds(), preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(false, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

