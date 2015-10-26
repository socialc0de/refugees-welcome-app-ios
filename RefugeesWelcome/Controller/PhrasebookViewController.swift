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

class PhrasebookViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var sectionsContainer: UICollectionView!
    
    var phrasebook = Phrasebook()
    var tableContainer: PhrasebookPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        sectionsContainer.dataSource = self
        sectionsContainer.delegate = self
        
        // get data
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        path = path.stringByAppendingPathComponent("phrasebook.archive")
        
        if let phrasebook = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? Phrasebook {
            self.phrasebook = phrasebook
            tableContainer.update()
        }
        tableContainer.phrasebook = phrasebook
        tableContainer.sectionSelector = sectionsContainer
        RequestHelper.loadDataFromUrl("http://pajowu.de:8080/phrasebook/all") { (jsonData) -> Void in
            self.phrasebook.phrases = jsonData["phrases"]
            self.phrasebook.save()
            self.tableContainer.update()
        }
        
        phrasebook.langauges = phrasebook.langauges.sort()

        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
        
        if let firstLanguageIndex = phrasebook.langauges.indexOf(phrasebook.firstLanguage) {
            pickerView.selectRow(firstLanguageIndex, inComponent: 0, animated: false)
        }
        if let targetLanguageIndex = phrasebook.langauges.indexOf(phrasebook.targetLanguage) {
            pickerView.selectRow(targetLanguageIndex, inComponent: 1, animated: false)
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
        
        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
        tableContainer.update()
    }
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("section", forIndexPath: indexPath) as! TranslationSectionsCell
        cell.sectionLabel.text = "Section \(indexPath.row)"
        cell.selected = tableContainer.currentSectionIndex == indexPath.row
        if cell.selected {
            cell.sectionLabel.textColor = cell.colorForSelectedState
        } else {
            cell.sectionLabel.textColor = UIColor.darkGrayColor()
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.tableContainer.goToSection(indexPath.row)
        self.sectionsContainer.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        self.sectionsContainer.reloadSections(NSIndexSet(index: 0))
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
        
        languageBtn.setTitle("\(phrasebook.firstLanguage) → \(phrasebook.targetLanguage)", forState: .Normal)
        tableContainer.update()
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!) {
        if (segue.identifier == "tableContainer") {
            tableContainer = segue!.destinationViewController as! PhrasebookPageViewController
        }
    }
}
