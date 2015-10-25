//
//  Phrasebook.swift
//  RefugeesWelcome
//
//  Created by Manuel Reich on 25/10/15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import SwiftyJSON

class Phrasebook: NSObject, NSCoding {
    var phrases = JSON("")
    var langauges = ["Turkish", "Portuguese", "Greek phonetic", "Spanish", "Finnish", "Hungarian", "Greek alphabet", "German", "Romanian", "Slovak / Czech", "Bosnian / Croatian / Serbian", "Arabic / Syrian Phonetic", "Kurdish (Kurmanji)", "Macedonian", "Dutch", "Russian", "Polish", "Arabic / Syrian", "Albanian", "English", "Italian"]
    let rightAligedLanguages = ["Arabic / Syrian"]
    
    var firstLanguage = "Arabic / Syrian"
    var targetLanguage = "German"
    
    
    // MARK: NSCoding
    override init() {
        
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let rawPhrases = decoder.decodeObjectForKey("rawphrases"),
//            let langauges = decoder.decodeObjectForKey("langauges") as? [String],
            let firstLanguage = decoder.decodeObjectForKey("firstLanguage") as? String,
            let targetLanguage = decoder.decodeObjectForKey("targetLanguage") as? String
            else { return nil }
        
        self.init()
        
        phrases = JSON(rawPhrases)

//        self.langauges = langauges
        self.firstLanguage = firstLanguage
        self.targetLanguage = targetLanguage
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        let rawPhrases = phrases.rawValue
        
        coder.encodeObject(rawPhrases, forKey: "rawphrases")
//        coder.encodeObject(langauges, forKey: "langauges")
        coder.encodeObject(firstLanguage, forKey: "firstLanguage")
        coder.encodeObject(targetLanguage, forKey: "targetLanguage")
    }
    
    func save() {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        path = path.stringByAppendingPathComponent("phrasebook.archive")
        
        NSKeyedArchiver.archiveRootObject(self, toFile: path as String)
    }


}
