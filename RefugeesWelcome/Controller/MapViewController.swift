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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestHelper.loadDataFromUrl("http://pajowu.de:8080/poi/all") { (jsonData) -> Void in
            let mapItems = jsonData["items"].arrayValue
            
            for jsonElem in mapItems {
                let latitude = (jsonElem["location"]["lat"].stringValue as NSString).doubleValue
                let longitude = (jsonElem["location"]["lng"].stringValue as NSString).doubleValue
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = "Hallo"
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}
