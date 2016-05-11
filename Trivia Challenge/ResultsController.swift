//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

class ResultsController: TemplateController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageType = "results"
        
        self.loadBackgroundColor()
        self.loadImages()
        self.loadInputs()
        self.loadButtons()
        self.loadText()
    }
}

