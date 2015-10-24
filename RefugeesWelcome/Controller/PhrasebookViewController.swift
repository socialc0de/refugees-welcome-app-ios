//
//  PhrasebookViewController.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhrasebookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var translationTable: UITableView!
    
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    let translationCellIdentifier = "translationCell"
    var phrases = JSON!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translationTable.dataSource = self
        translationTable.delegate = self
        
        let jsonFilePath:NSString = NSBundle.mainBundle().pathForResource("src/phrases/animals.json", ofType: "json")!
        let jsonData:NSData = NSData.dataWithContentsOfMappedFile(jsonFilePath as String) as! NSData
        let error:NSError?
        phrases = JSON(data: jsonData)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phrases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("translationCell", forIndexPath: indexPath) as! TranslationTableViewCell
        cell.firstLanguageLabel.text = phrases['German'].stringValue
        cell.targetLanguageLabel.text = phrases['English'].stringValue
        
        return cell
    }
}
