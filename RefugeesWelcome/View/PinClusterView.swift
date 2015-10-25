//
//  MapClusterAnnotationView.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit

class PinClusterView: MKAnnotationView {
    
    weak var countLabel: UILabel!
    
    var oneLocation = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    var count = 1 {
        didSet {
            self.countLabel.text = (count > 1) ? "\(count)" : ""
            self.setNeedsLayout()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.createCountLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func createCountLabel() {
        let countLabel = UILabel(frame: self.bounds)
        countLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.font = UIFont.boldSystemFontOfSize(12)

        countLabel.textColor = UIColor.blackColor()
        
        self.countLabel = countLabel
        self.addSubview(countLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var image: UIImage?
        var centerOffset = CGPointZero
        
        if oneLocation {
            image = UIImage(named: "MarkerSquare")
            centerOffset = CGPointMake(0, image!.size.height * 0.5)
            var frame = self.bounds
            frame.origin.y -= 2
            self.countLabel.frame = frame
        } else {
            self.countLabel.frame = self.bounds
            
            var imageName = "MarkerCircle"
            
            switch self.count {
            case 1..<20: imageName += "XS"
            case 20..<50: imageName += "S"
            case 50..<70: imageName += "M"
            case 70..<90: imageName += "L"
            default: imageName += "XL"
            }
            
            image = UIImage(named: imageName)
        }
        
        self.image = image;
        self.centerOffset = centerOffset;
    }
}
