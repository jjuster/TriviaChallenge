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
        if (self.viewDictionary["start_over_button"] != nil) {
            let startOverButton : UIButton = self.viewDictionary["start_over_button"] as! UIButton
            startOverButton.addTarget(self, action: #selector(self.restart), forControlEvents: .TouchUpInside)
        }
    }
}

