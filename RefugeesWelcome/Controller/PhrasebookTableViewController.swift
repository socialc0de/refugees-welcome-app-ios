//
//  PhrasebookViewController.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PhrasebookTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var translationTable: UITableView!
    let translationCellIdentifier = "translationCell"
    
    var phrasebook = Phrasebook()
    var sortedPhrases = [[(firstLanguagePhrase: String, targetLanguagePhrase: String)]]()
    var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translationTable.dataSource = self
        translationTable.delegate = self
        
        
        self.buildOrUpdatePhraseList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedPhrases.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPhrases[section].count
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionNames
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(translationCellIdentifier, forIndexPath: indexPath) as! TranslationTableViewCell
        
        cell.firstLanguageLabel.text = sortedPhrases[indexPath.section][indexPath.row].firstLanguagePhrase
        cell.targetLanguageLabel.text = sortedPhrases[indexPath.section][indexPath.row].targetLanguagePhrase
        
        if phrasebook.rightAligedLanguages.contains(phrasebook.firstLanguage) {
            cell.firstLanguageLabel.textAlignment = .Right
        } else {
            cell.firstLanguageLabel.textAlignment = .Left
        }
        if phrasebook.rightAligedLanguages.contains(phrasebook.targetLanguage) {
            cell.targetLanguageLabel.textAlignment = .Right
        } else {
            cell.targetLanguageLabel.textAlignment = .Left
        }
        
        return cell
    }
    
    // MARK: helper
    
    func buildOrUpdatePhraseList() {
        sortedPhrases.removeAll()
        sectionNames.removeAll()
        
        var cleanPhrases = [(firstLanguagePhrase: String, targetLanguagePhrase: String)]()
        
        // clean phrases
        for phraseSet in phrasebook.phrases.arrayValue {
            var firstLanguagePhrase = phraseSet[phrasebook.firstLanguage].stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var targetLanguagePhrase = phraseSet[phrasebook.targetLanguage].stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            firstLanguagePhrase = firstLanguagePhrase.stringByReplacingOccurrencesOfString("\n", withString: " ")
            targetLanguagePhrase = targetLanguagePhrase.stringByReplacingOccurrencesOfString("\n", withString: " ")
            
            if firstLanguagePhrase != "" && targetLanguagePhrase != "" {
                cleanPhrases.append((firstLanguagePhrase: firstLanguagePhrase, targetLanguagePhrase: targetLanguagePhrase))
            }
        }
        
        cleanPhrases = cleanPhrases.sort({ $0.firstLanguagePhrase < $1.firstLanguagePhrase })
        
        // build sections
        var section: Character?
        var index = -1
        for phraseSet in cleanPhrases {
            
            let indexLetter = phraseSet.firstLanguagePhrase.uppercaseString[phraseSet.firstLanguagePhrase.startIndex]
            
            if indexLetter != section {
                section = indexLetter
                index += 1
                sectionNames.append(String(section!))
                sortedPhrases.append([(firstLanguagePhrase: String, targetLanguagePhrase: String)]())
            }
            
            sortedPhrases[index].append((firstLanguagePhrase: phraseSet.firstLanguagePhrase, targetLanguagePhrase: phraseSet.targetLanguagePhrase))
        }
        
        translationTable.reloadData()
    }
    
}
