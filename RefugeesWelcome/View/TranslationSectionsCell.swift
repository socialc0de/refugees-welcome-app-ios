//
//  TranslationSectionsCell.swift
//  RefugeesWelcome
//
//  Created by Manuel Reich on 25/10/15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit

class TranslationSectionsCell: UICollectionViewCell {
    
    var onsectionButtonClicked: (() -> Void)?
    
    @IBOutlet weak var sectionButton: UIButton!
    @IBAction func sectionButtonClicked() {
        if let onsectionButtonClicked = onsectionButtonClicked {
            onsectionButtonClicked()
        }
    }
}
