//
//  Trivia Challenge
//
//  Created by Josh Juster on 5/11/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class TemplateController: UIViewController {
    var pageType: String { return "" }
    var gameCode : String?
    var placeholderImages : [String:UIImage] = [String:UIImage]()
    
    var tagIndex : Int = 0
    var viewTags : [String: Int] = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let am = AssetManager.sharedInstance
        if (am.game != nil && am.game!["theme"]["pages"][self.pageType].exists()) {
            self.loadBackgroundColor()
            self.loadImages()
            self.loadInputs()
            self.loadButtons()
            self.loadText()
        }
    }
    
    func loadImages() {
        let am = AssetManager.sharedInstance
        let multiple = am.gameMultiple(self.pageType)
        
        let objectsJson = am.getObjects(self.pageType, objectType: .IMAGE)
        
        if (objectsJson != nil) {
            for objectJson in objectsJson! {
                let title = objectJson["title"].stringValue
                let w = objectJson["width"].floatValue / Float(multiple.x)
                let h = objectJson["height"].floatValue / Float(multiple.y)
                
                let data = NSData(contentsOfURL: am.filePath(self.pageType, objectType: .IMAGE, title: title)!)
                let image = UIImage(data: data!)!.scaleTo(UIScreen.mainScreen().scale)
                
                if (objectJson["x"].exists() && objectJson["y"].exists()) {
                    let x = objectJson["x"].floatValue / Float(multiple.x)
                    let y = objectJson["y"].floatValue / Float(multiple.y)
                    
                    let imageView = UIImageView(image: image)
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(imageView)
                    imageView.tag = self.setTag(title)
                    self.view.addConstraintFormat("H:|-(\(x))-[\(title)(\(w))]", views: [title: imageView])
                    self.view.addConstraintFormat("V:|-(\(y))-[\(title)(\(h))]", views: [title: imageView])
                } else {
                    self.placeholderImages[title] = image
                }
            }
        }
    }
    
    func setTag(title: String) -> Int {
        self.tagIndex += 1
        self.viewTags[title] = self.tagIndex
        return self.tagIndex
    }
    
    func loadText() {
        let am = AssetManager.sharedInstance
        let multiple = am.gameMultiple(self.pageType)
        
        let objectsJson = am.getObjects(self.pageType, objectType: .TEXT)
        
        if (objectsJson != nil) {
            for objectJson in objectsJson! {
                let title = objectJson["title"].stringValue
                let x = objectJson["x"].floatValue / Float(multiple.x)
                let y = objectJson["y"].floatValue / Float(multiple.y)
                let w = objectJson["width"].floatValue / Float(multiple.x)
                var h = objectJson["height"].floatValue / Float(multiple.y)
                
                var text: String?
                var size: Float?
                var color: UIColor?
                var justification: NSTextAlignment?
                var gameText : String?
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                
                if (objectJson["text"].exists()) {
                    text = objectJson["text"].stringValue
                    
                    if (objectJson["size"].exists()) {
                        size = objectJson["size"].floatValue
                    } else {
                        size = 24.0
                    }
                    
                    if (objectJson["color"].exists()) {
                        color = UIColor(hex: objectJson["color"].stringValue)
                    } else {
                        color = UIColor.blackColor()
                    }
                    
                    if (objectJson["justification"].exists()) {
                        justification = self.parseJustification(objectJson["justification"].stringValue)
                    } else {
                        justification = NSTextAlignment.Center
                    }
                    
                    label.font = UIFont(name: "Gotham", size: CGFloat(size!))
                    label.textColor = color!
                    label.textAlignment = justification!
                    label.adjustsFontSizeToFitWidth = true
                    
                    gameText = self.addGameState(text)
                    if (gameText != nil) {
                        label.text = gameText!
                    }
                }
                
                if (text != nil && gameText == nil) {
                    break
                }
                
                if (h == 0) {
                    h = size!
                }
                
                self.view.addSubview(label)
                label.tag = self.setTag(title)
                self.view.addConstraintFormat("H:|-(\(x))-[\(title)(\(w))]", views: [title: label])
                self.view.addConstraintFormat("V:|-(\(y))-[\(title)(\(h))]", views: [title: label])
            }
        }
    }
    
    func parseJustification(justification: String) -> NSTextAlignment {
        switch justification {
        case "left":
            return NSTextAlignment.Left
        case "center":
            return NSTextAlignment.Center
        case "right":
            return NSTextAlignment.Right
        case "justified":
            return NSTextAlignment.Justified
        default:
            return NSTextAlignment.Center
        }
    }
    
    func loadButtons() {
        let am = AssetManager.sharedInstance
        let multiple = am.gameMultiple(self.pageType)
        
        let objectsJson = am.getObjects(self.pageType, objectType: .BUTTON)
        
        if (objectsJson != nil) {
            for objectJson in objectsJson! {
                let title = objectJson["title"].stringValue
                let x = objectJson["x"].floatValue / Float(multiple.x)
                let y = objectJson["y"].floatValue / Float(multiple.y)
                let w = objectJson["width"].floatValue / Float(multiple.x)
                let h = objectJson["height"].floatValue / Float(multiple.y)
                
                var text: String?
                var size: Float?
                var color: UIColor?
                var justification: NSTextAlignment?
                
                var gameText: String?

                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false

                if (objectJson["text"].exists()) {
                    text = objectJson["text"].stringValue
                    
                    if (objectJson["size"].exists()) {
                        size = objectJson["size"].floatValue
                    } else {
                        size = 24.0
                    }
                    
                    if (objectJson["color"].exists()) {
                        color = UIColor(hex: objectJson["color"].stringValue)
                    } else {
                        color = UIColor.blackColor()
                    }
                    
                    if (objectJson["justification"].exists()) {
                        justification = self.parseJustification(objectJson["justification"].stringValue)
                    } else {
                        justification = NSTextAlignment.Center
                    }
                    
                    button.titleLabel!.font = UIFont(name: "Gotham", size: CGFloat(size!))
                    button.titleLabel!.textColor = color!
                    button.contentVerticalAlignment = .Center
                    button.titleLabel!.adjustsFontSizeToFitWidth = true
                    button.titleLabel!.textAlignment = justification!
                    
                    gameText = self.addGameState(text)
                    if (gameText != nil) {
                        button.setTitle(gameText, forState: .Normal)
                    }
                }
                
                if (text == nil || gameText != nil) {
                    let url = am.filePath(self.pageType, objectType: .BUTTON, title: title)
                    if (url != nil) {
                        let data = NSData(contentsOfURL: url!)
                        let image = UIImage(data: data!)!.scaleTo(UIScreen.mainScreen().scale)
                        
                        button.setBackgroundImage(image, forState: .Normal)
                    }
                    
                    self.view.addSubview(button)
                    button.tag = self.setTag(title)
                    self.view.addConstraintFormat("H:|-(\(x))-[\(title)(\(w))]", views: [title: button])
                    self.view.addConstraintFormat("V:|-(\(y))-[\(title)(\(h))]", views: [title: button])
                }
            }
        }
    }
    
    func loadInputs() {
        let am = AssetManager.sharedInstance
        let multiple = am.gameMultiple(self.pageType)
        
        let objectsJson = am.getObjects(self.pageType, objectType: .INPUT)
        
        if (objectsJson != nil) {
            for objectJson in objectsJson! {
                let title = objectJson["title"].stringValue
                let x = objectJson["x"].floatValue / Float(multiple.x)
                let y = objectJson["y"].floatValue / Float(multiple.y)
                let w = objectJson["width"].floatValue / Float(multiple.x)
                let h = objectJson["height"].floatValue / Float(multiple.y)
                
                var size: Float?
                if (objectJson["size"].exists()) {
                    size = objectJson["size"].floatValue
                } else {
                    size = 18.0
                }
                
                var color: UIColor?
                if (objectJson["color"].exists()) {
                    color = UIColor(hex: objectJson["color"].stringValue)
                } else {
                    color = UIColor.blackColor()
                }
                
                var justification: NSTextAlignment?
                if (objectJson["justification"].exists()) {
                    justification = self.parseJustification(objectJson["justification"].stringValue)
                } else {
                    justification = NSTextAlignment.Center
                }
                
                let textField = UITextField()
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                let data = NSData(contentsOfURL: am.filePath(self.pageType, objectType: .INPUT, title: title)!)
                let image = UIImage(data: data!)!.scaleTo(UIScreen.mainScreen().scale)
                
                textField.background = image
                textField.font = UIFont(name: "Gotham", size: CGFloat(size!))
                textField.textColor = color!
                textField.contentVerticalAlignment = .Center
                textField.textAlignment = justification!
                
                self.view.addSubview(textField)
                textField.tag = self.setTag(title)
                self.view.addConstraintFormat("H:|-(\(x))-[\(title)(\(w))]", views: [title: textField])
                self.view.addConstraintFormat("V:|-(\(y))-[\(title)(\(h))]", views: [title: textField])
            }
        }
    }
    
    func addGameState(input: String?) -> String? {
        if (input == nil) {
            return nil
        }
        
        let am = AssetManager.sharedInstance
        let gameState = am.gameState!
        
        let props = matchesForRegexInText("\\[(.*?)\\]", text: input)
        
        var newStr = input!
        
        for prop in props {
            let propVal = gameState.getProp(prop)
            if (propVal == nil) {
                return nil
            }
            newStr = newStr.stringByReplacingOccurrencesOfString(prop, withString: propVal!)
        }
        
        return (newStr == "") ? nil : newStr
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func loadBackgroundColor() {
        let am = AssetManager.sharedInstance
        let backgroundColor = am.getProperty(self.pageType, title: "background_color")
        if (backgroundColor != nil) {
            self.view.backgroundColor = UIColor(hex: backgroundColor!)
        }
    }
    
    func restart() {
        let am = AssetManager.sharedInstance
        am.reloadGameState()

        let vc = self.navigationController!.viewControllers.first
        vc?.viewDidLoad()
        self.navigationController!.popToRootViewControllerAnimated(false)
    }
    
    func loadVC(vc: UIViewController) {
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}