//
//  Authority.swift
//  RefugeesWelcome
//
//  Created by Anna on 25.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import SwiftyJSON

class Authority: NSObject {
    
    var openingTime = ""
    var website = ""
    var email = ""
    var phone = ""
    var address = ""
    var lon = ""
    var lat = ""
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
    }
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        self.openingTime = json["offnungszeiten"].stringValue
        self.website = json["website"].stringValue
        self.address = json["adresse"].stringValue
        self.phone = json["telefon"].stringValue
        self.lon = json["location"]["lng"].stringValue
        self.lat = json["location"]["lat"].stringValue
        self.email = json["email"].stringValue
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.openingTime = decoder.decodeObjectForKey("openingTime") as! String
        self.website = decoder.decodeObjectForKey("website") as! String
        self.email = decoder.decodeObjectForKey("email") as! String
        self.phone = decoder.decodeObjectForKey("phone") as! String
        self.address = decoder.decodeObjectForKey("address") as! String
        self.lon = decoder.decodeObjectForKey("lon") as! String
        self.lat = decoder.decodeObjectForKey("lat") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(openingTime, forKey: "openingTime")
        coder.encodeObject(website, forKey: "website")
        coder.encodeObject(email, forKey: "email")
        coder.encodeObject(phone, forKey: "phone")
        coder.encodeObject(address, forKey: "address")
        coder.encodeObject(lon, forKey: "lon")
        coder.encodeObject(lat, forKey: "lat")
    }
    
    func save() {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        path = path.stringByAppendingPathComponent("authority.archive")
        NSKeyedArchiver.archiveRootObject(self, toFile: path as String)
    }
}
