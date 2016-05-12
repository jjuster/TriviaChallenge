//
//  AssetManager.swift
//  Trivia Challenge
//
//  Created by Josh Juster on 5/10/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AssetManager : NSObject {
    #if DEBUG
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            //let host = "http://local.pradux.com"
            let host = "https://mc-challenge.herokuapp.com"
        #else
            let host = "https://mc-challenge.herokuapp.com"
        #endif
    #else
        let host = "https://mc-challenge.herokuapp.com"
    #endif
    
    var game: JSON?
    
    var gameState: Game?

    enum TriviaError: Int {
        case
        NoCode           = 0,
        InvalidCode      = 1,
        PageMissing      = 2,
        NoQuestions      = 3,
        NoTheme          = 4,
        UnknownError     = 5,
        WriteError       = 6,
        ParseError       = 7,
        MissingFile      = 8,
        NoError          = -1
    }
    
    enum ObjectType: String {
        case
        PROP            = "",
        IMAGE           = "images",
        BUTTON          = "buttons",
        TEXT            = "text",
        INPUT           = "inputs"
    }
    
    static let sharedInstance = AssetManager()
    
    func saveGame(game: JSON, success: (() -> Void), failure: ((error: AssetManager.TriviaError) -> Void)) {
        
        var error : AssetManager.TriviaError = .NoError
        let code = game["code"].stringValue
        var dir : NSURL?
        do {
            try dir = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        } catch _ {
            error = .WriteError
        }

        let gamePath = dir!.URLByAppendingPathComponent(code)
        let backupPath = dir!.URLByAppendingPathComponent("old")
        
        do {
            try NSFileManager.defaultManager().moveItemAtURL(gamePath, toURL: backupPath)
        } catch _ {}
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(gamePath, withIntermediateDirectories: false, attributes: nil)
        } catch _ {
            error = .WriteError
        }
        
        if (game["theme"].exists()) {
            let theme = game["theme"]
            if (theme["pages"].exists()) {
                for (pageType, page):(String, JSON) in theme["pages"] {
                    let pagePath = gamePath.URLByAppendingPathComponent(pageType)
                    
                    do {
                        try NSFileManager.defaultManager().createDirectoryAtURL(pagePath, withIntermediateDirectories: false, attributes: nil)
                    } catch _ {
                        error = .WriteError
                    }
                    
                    for objectType in [ObjectType.IMAGE, ObjectType.BUTTON, ObjectType.INPUT] {
                        let objectPath = pagePath.URLByAppendingPathComponent(objectType.rawValue)
                        
                        do {
                            try NSFileManager.defaultManager().createDirectoryAtURL(objectPath, withIntermediateDirectories: false, attributes: nil)
                        } catch _ {
                            error = .WriteError
                        }
                        
                        let objects : Array = page[objectType.rawValue].arrayValue
                        
                        for objectJson : JSON in objects {
                            let imageSource = objectJson["source"].stringValue
                            if (imageSource != "") {
                                let imageUrl = NSURL(string: imageSource)
                                let data = NSData(contentsOfURL: imageUrl!)
                                if (data != nil) {
                                    let image = UIImage(data: NSData(contentsOfURL: imageUrl!)!)
                                    
                                    if let data = UIImagePNGRepresentation(image!) {
                                        let fileURL = objectPath.URLByAppendingPathComponent("\(objectJson["title"].stringValue).png")
                                        
                                        do {
                                            try data.writeToURL(fileURL, options: .AtomicWrite)
                                        } catch _ {
                                            error = .WriteError
                                        }
                                    }
                                } else {
                                    print(imageUrl)
                                    error = .MissingFile
                                }
                            } else {
                                error = .ParseError
                            }
                        }
                    }
                }
            } else {
                error = .ParseError
            }
        } else {
            error = .ParseError
        }
        
        if (error == .NoError) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(game.rawString(), forKey: "CurrentGame")
            
            do {
                try NSFileManager.defaultManager().removeItemAtURL(backupPath)
            } catch _ {}
            
            self.loadGame()
            
            success()
        } else {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(backupPath)
                try NSFileManager.defaultManager().moveItemAtURL(backupPath, toURL: gamePath)
            } catch _ {}
            
            failure(error: error)
        }
    }
    
    func filePath(page: String, objectType: AssetManager.ObjectType, title: String) -> NSURL? {
        if (self.gameCode() == nil) {
            return nil
        }
        
        var dir : NSURL?
        do {
            try dir = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        } catch _ {
            return nil
        }
        
        let objectPath = dir!.URLByAppendingPathComponent("\(self.gameCode()!)/\(page)/\(objectType.rawValue)")
        
        return objectPath.URLByAppendingPathComponent("\(title).png")
    }
    
    func loadGame() -> JSON? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.valueForKey("CurrentGame") != nil) {
            self.game = JSON.parse(defaults.valueForKey("CurrentGame") as! String)
                        
            return self.game
        } else {
            return nil
        }
    }
    
    func getProperty(pageType: String, title: String) -> String? {
        let prop = self.getObject(pageType, objectType: .PROP, title: title)        
        return (prop != nil) ? prop!.stringValue : nil
    }
    
    func gameCode() -> String? {
        return (self.game != nil) ? self.game!["code"].string : nil
    }
    
    func reloadGameState() {
        self.gameState = Game()
        
        if (self.game == nil) {
            return
        }
        
        self.gameState!.randomizeQuestions = self.game!["randomize_questions"].boolValue
        self.gameState!.numberQuestions = self.game!["number_of_questions"].int
        self.gameState!.lowScoreMessage = self.game!["low_score_message"].stringValue
        self.gameState!.mediumScoreMessage = self.game!["medium_score_message"].stringValue
        self.gameState!.highScoreMessage = self.game!["high_score_message"].stringValue
        self.gameState!.perfectScoreMessage = self.game!["perfect_score_message"].stringValue
        
        for questionJson in self.game!["questions"].arrayValue {
            let question = Question()
            question.question = questionJson["question"].stringValue
            question.correctAnswer = questionJson["correct_answer"].intValue
            
            if (questionJson["answer_1"].exists()) {
                question.answer_1 = questionJson["answer_1"].stringValue
            }
            
            if (questionJson["answer_2"].exists()) {
                question.answer_2 = questionJson["answer_2"].stringValue
            }
            
            if (questionJson["answer_3"].exists()) {
                question.answer_3 = questionJson["answer_3"].stringValue
            }
            
            if (questionJson["answer_4"].exists()) {
                question.answer_4 = questionJson["answer_4"].stringValue
            }
            
            if (questionJson["answer_5"].exists()) {
                question.answer_5 = questionJson["answer_5"].stringValue
            }
            
            self.gameState!.questions.append(question)
        }
        
        if (self.gameState!.numberQuestions == nil) {
            self.gameState!.numberQuestions = self.gameState!.questions.count
        } else {
            self.gameState!.numberQuestions = [self.gameState!.numberQuestions!, self.gameState!.questions.count].minElement()
        }
        
        if (self.gameState!.randomizeQuestions) {
            self.gameState!.questions.shuffleInPlace()
        }
    }
    
    func gameDimensions(pageType: String) -> CGSize {
        let width = Float(self.getProperty(pageType, title: "width")!)
        let height = Float(self.getProperty(pageType, title: "height")!)
        
        return CGSizeMake(CGFloat(width!), CGFloat(height!))
    }
    
    func gameMultiple(pageType: String) -> CGPoint {
        let sz = self.gameDimensions(pageType)

        return CGPointMake(sz.width / UIScreen.mainScreen().bounds.width, sz.height / UIScreen.mainScreen().bounds.height)
    }
    
    func getObject(pageType: String, objectType: AssetManager.ObjectType, title: String) -> JSON? {
        if (self.game == nil) { self.loadGame() }
        if (self.game != nil) {
            if (objectType == .PROP) {
                return self.game!["theme"]["pages"][pageType][title]
            } else {
                return self.game!["theme"]["pages"][pageType][objectType.rawValue].arrayValue.filter { $0["title"].stringValue == title }.first
            }
        } else {
            return nil
        }
    }
    
    func getObjects(pageType: String, objectType: AssetManager.ObjectType) -> [JSON]? {
        if (self.game == nil) { self.loadGame() }
        if (self.game != nil) {
            return self.game!["theme"]["pages"][pageType][objectType.rawValue].arrayValue
        } else {
            return nil
        }
    }
    
    func load(code: String, success: ((JSON) -> Void), failure: ((error: AssetManager.TriviaError) -> Void)) {
        let url = "\(host)/assets/load?code=\(code.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))"
        print("URL:",url)
        Alamofire.request(.GET, url, encoding: .JSON)
            .responseJSON { response in                
                switch response.result {
                case .Success:
                    if let blob = response.result.value {
                        let json = JSON(blob)
                        
                        if (json["status"] == "success") {
                            success(json["game"])
                        } else {
                            failure(error: AssetManager.TriviaError(rawValue: json["error_code"].intValue)!)
                        }
                    }
                case .Failure:
                    failure(error: .UnknownError)
                }
        }
    }
}