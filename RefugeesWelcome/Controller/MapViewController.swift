//
//  MapViewController.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var coordinates = [String]()
    var currentRow = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJSONDataFromFile()
    }
    
    func loadJSONDataFromFile() {
        if let path = NSBundle.mainBundle().pathForResource("authorities", ofType: "json") {
            let fileContent: NSString?
            do {
                fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            } catch _ {
                fileContent = nil
            }
            
            if let content = fileContent {
                if let dataFromString = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    if let json = JSON(data: dataFromString).array {
                        for jsonElem in json {
                            let lat = jsonElem["location"]["lat"].stringValue
                            let lng = jsonElem["location"]["lng"].stringValue
                            
                            print("LAT: \(lat), LNG: \(lng)")
                            
                            let latitude = (lat as NSString).doubleValue
                            let longitude = (lng as NSString).doubleValue
                            
                            //let coordination = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lng as NSString).doubleValue)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            annotation.title = "Hallo"
                            mapView.addAnnotation(annotation)
                        }
                    }
                }
            } else {
                print("Schade")
            }
        }
    }
}
