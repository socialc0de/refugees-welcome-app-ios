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
    var phrases = [JSON]()
    var langauges = ["Turkish", "Portuguese", "Greek phonetic", "Spanish", "Finnish", "Hungarian", "Greek alphabet", "German", "Romanian", "Slovak / Czech", "Bosnian / Croatian / Serbian", "Arabic / Syrian Phonetic", "Kurdish (Kurmanji)", "Macedonian", "Dutch", "Russian", "Polish", "Arabic / Syrian", "Albanian", "English", "Italian"]
    let rightAligedLanguages = ["Arabic / Syrian"]
    
    var firstLanguage = "Arabic / Syrian"
    var targetLanguage = "German"
    var cleanPhrases = [(firstLanguagePhrase: String, targetLanguagePhrase: String)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translationTable.dataSource = self
        translationTable.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        langauges = langauges.sort()
        
        languageBtn.setTitle("\(firstLanguage) → \(targetLanguage)", forState: .Normal)
        
        if let firstLanguageIndex = langauges.indexOf(firstLanguage) {
            pickerView.selectRow(firstLanguageIndex, inComponent: 0, animated: false)
        }
        if let targetLanguageIndex = langauges.indexOf(targetLanguage) {
            pickerView.selectRow(targetLanguageIndex, inComponent: 1, animated: false)
        }
        
        RequestHelper.loadDataFromUrl("http://pajowu.de:8080/phrasebook/all") { (jsonData) -> Void in
            self.phrases = jsonData["phrases"].arrayValue
            self.buildOrUpdatePhraseList()
        }
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
    }

    @IBAction func onExchangeLanguagesBtnClicked() {
        let temp = firstLanguage
        firstLanguage = targetLanguage
        targetLanguage = temp
        
        if let firstLanguageIndex = langauges.indexOf(firstLanguage) {
            pickerView.selectRow(firstLanguageIndex, inComponent: 0, animated: true)
        }
        if let targetLanguageIndex = langauges.indexOf(targetLanguage) {
            pickerView.selectRow(targetLanguageIndex, inComponent: 1, animated: true)
        }

        buildOrUpdatePhraseList()
        languageBtn.setTitle("\(firstLanguage) → \(targetLanguage)", forState: .Normal)
    }

    // MARK: Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleanPhrases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(translationCellIdentifier, forIndexPath: indexPath) as! TranslationTableViewCell
        
        cell.firstLanguageLabel.text = cleanPhrases[indexPath.row].firstLanguagePhrase
        cell.targetLanguageLabel.text = cleanPhrases[indexPath.row].targetLanguagePhrase
        
        if rightAligedLanguages.contains(firstLanguage) {
            cell.firstLanguageLabel.textAlignment = .Right
        } else {
            cell.firstLanguageLabel.textAlignment = .Left
        }
        if rightAligedLanguages.contains(targetLanguage) {
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
        return langauges.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return langauges[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            firstLanguage = langauges[row]
        } else if component == 1 {
            targetLanguage = langauges[row]
        }
        
        buildOrUpdatePhraseList()
        languageBtn.setTitle("\(firstLanguage) → \(targetLanguage)", forState: .Normal)
    }
    
    
    // MARK: helper
    
    func buildOrUpdatePhraseList() {
        cleanPhrases.removeAll()
        
        for phraseSet in phrases {
            var firstLanguagePhrase = phraseSet[firstLanguage].stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var targetLanguagePhrase = phraseSet[targetLanguage].stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            firstLanguagePhrase = firstLanguagePhrase.stringByReplacingOccurrencesOfString("\n", withString: " ")
            targetLanguagePhrase = targetLanguagePhrase.stringByReplacingOccurrencesOfString("\n", withString: " ")
            
            if firstLanguagePhrase != "" && targetLanguagePhrase != "" {
                cleanPhrases.append((firstLanguagePhrase: firstLanguagePhrase, targetLanguagePhrase: targetLanguagePhrase))
            }
        }
        
        cleanPhrases = cleanPhrases.sort({ $0.firstLanguagePhrase < $1.firstLanguagePhrase })
        
        translationTable.reloadData()
    }
    
}
