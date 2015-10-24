//
//  TranslationTableViewCell.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit

class TranslationTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
