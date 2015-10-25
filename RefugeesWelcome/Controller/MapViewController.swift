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
import CCHMapClusterController

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modeBtn: UIBarButtonItem!
    
    var mapClusterController: CCHMapClusterController?
    var locationManager: CLLocationManager?
    enum ClusterType {
        case Wifi, Authorities
    }
    
    var currentMode = ClusterType.Authorities
    
    
    @IBAction func modeBtnPressed(sender: UIBarButtonItem) {
        currentMode = (currentMode == .Wifi) ? .Authorities : .Wifi
        print("new mode is \(currentMode)")
        setUpClusterer()
    }
    
    @IBAction func positionBtnPressed() {
        if let userLocation:CLLocation = locationManager?.location {
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        setUpClusterer()
    }
    
    func setUpMap() {
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        mapClusterController = CCHMapClusterController(mapView: self.mapView)
        mapClusterController?.delegate = self
        
        //zoom to user location
        positionBtnPressed()
    }
    
    func loadAnnotations(type: ClusterType) {
        var annotations = [MKPointAnnotation]()
        var url = "http://pajowu.de:8080/poi/"
        url += type == .Wifi ? "wifi" : "authorities"
        
        RequestHelper.loadDataFromUrl(url) { (jsonData) -> Void in
            let mapItems = jsonData["items"].arrayValue
            
            for jsonElem in mapItems {
                let latitude = (jsonElem["location"]["lat"].stringValue as NSString).doubleValue
                let longitude = (jsonElem["location"]["lng"].stringValue as NSString).doubleValue
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = jsonElem["addresse"].stringValue
                annotations.append(annotation)
            }
            self.mapClusterController?.addAnnotations(annotations, withCompletionHandler: nil)
        }
    }
    
    func setUpClusterer() {
        let annotationsToRemove = mapClusterController!.annotations
        mapClusterController?.removeAnnotations(Array(annotationsToRemove), withCompletionHandler: nil)
        loadAnnotations(currentMode)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager?.startUpdatingLocation()
        } else {
            mapView.showsUserLocation = false
            locationManager?.stopUpdatingLocation()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CCHMapClusterAnnotation {
            let identifier = "clusterAnnotation"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? PinClusterView
            if pinView == nil {
                pinView = PinClusterView(annotation: annotation, reuseIdentifier: identifier)
                pinView?.canShowCallout = true
            } else {
                pinView?.annotation = annotation
            }
            
            pinView?.count = annotation.annotations.count
            pinView?.oneLocation = annotation.isUniqueLocation()
            
            return pinView
        }
        return nil
    }
}

extension MapViewController: CCHMapClusterControllerDelegate {
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        return "\(mapClusterAnnotation.annotations.count) Items"
    }
}
