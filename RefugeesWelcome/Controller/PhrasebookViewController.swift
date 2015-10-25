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

class PhrasebookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var translationTable: UITableView!
    
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let translationCellIdentifier = "translationCell"
    
    var phrasebook = Phrasebook()
    var sortedPhrases = [[(firstLanguagePhrase: String, targetLanguagePhrase: String)]]()
    var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        path = path.stringByAppendingPathComponent("phrasebook.archive")
        
        if let phrasebook = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? Phrasebook {
            self.phrasebook = phrasebook
        }
        
        
        translationTable.dataSource = self
        translationTable.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        phrasebook.langauges = phrasebook.langauges.sort()
        
        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
        
        if let firstLanguageIndex = phrasebook.langauges.indexOf(phrasebook.firstLanguage) {
            pickerView.selectRow(firstLanguageIndex, inComponent: 0, animated: false)
        }
        if let targetLanguageIndex = phrasebook.langauges.indexOf(phrasebook.targetLanguage) {
            pickerView.selectRow(targetLanguageIndex, inComponent: 1, animated: false)
        }
        
        RequestHelper.loadDataFromUrl("http://pajowu.de:8080/phrasebook/all") { (jsonData) -> Void in
            self.phrasebook.phrases = jsonData["phrases"]
            self.buildOrUpdatePhraseList()
        }
        
        self.buildOrUpdatePhraseList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLanguageBtnClicked() {
        pickerContainerView.hidden = false
    }
    
    @IBAction func onLanguageSelectSubmit() {
        pickerContainerView.hidden = true
        phrasebook.save()
    }

    @IBAction func onExchangeLanguagesBtnClicked() {
        let temp = phrasebook.firstLanguage
        phrasebook.firstLanguage = phrasebook.targetLanguage
        phrasebook.targetLanguage = temp
        
        if let firstLanguageIndex = phrasebook.langauges.indexOf(phrasebook.firstLanguage) {
            pickerView.selectRow(firstLanguageIndex, inComponent: 0, animated: true)
        }
        if let targetLanguageIndex = phrasebook.langauges.indexOf(phrasebook.targetLanguage) {
            pickerView.selectRow(targetLanguageIndex, inComponent: 1, animated: true)
        }

        buildOrUpdatePhraseList()
        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
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
    
    // MARK: Picker View
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phrasebook.langauges.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return phrasebook.langauges[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            phrasebook.firstLanguage = phrasebook.langauges[row]
        } else if component == 1 {
            phrasebook.targetLanguage = phrasebook.langauges[row]
        }
        
        buildOrUpdatePhraseList()
        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
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
