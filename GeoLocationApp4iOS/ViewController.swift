//
//  ViewController.swift
//  GeoLocationApp4iOS
//
//  Created by Vanessa Hernandez Mateos on 8/30/17.
//  Copyright © 2017 Vanessa Hernandez Mateos. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var currentLocationLabel:UILabel!
    var locationManager:CLLocationManager!
    var lastLocation:CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let title = UILabel(frame: CGRect(x:0, y:80, width: view.frame.width, height:30))
        title.text = "Wellcome to the GeoLocation iOS App"
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont(name: "ArialMT", size: 18)
        view.addSubview(title)
        
        let label1 = UILabel(frame: CGRect(x:0, y:title.frame.maxY+20, width: view.frame.width, height:20))
        label1.text = "Your current location is:"
        label1.textAlignment = NSTextAlignment.center
        label1.font = UIFont(name: "ArialMT", size: 14)
        view.addSubview(label1)
        
        currentLocationLabel = UILabel(frame: CGRect(x: 0, y: label1.frame.maxY+20, width: view.frame.width, height: 20))
        currentLocationLabel.text = "--Location--"
        currentLocationLabel.textAlignment = NSTextAlignment.center
        currentLocationLabel.font = UIFont(name: "ArialMT", size: 14)
        view.addSubview(currentLocationLabel)
        
        let updateButton = UIButton(frame: CGRect(x: 50, y: currentLocationLabel.frame.maxY+30, width: view.frame.width-100, height: 30))
        updateButton.setTitle("Update", for: UIControlState.normal)
        updateButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        updateButton.backgroundColor = UIColor.purple
        updateButton.addTarget(self, action: #selector(updateUI), for: UIControlEvents.touchUpInside)
        view.addSubview(updateButton)
        
        updateUI()
}
    
    
    func updateUI(){
        if CLLocationManager.locationServicesEnabled(){
            if let _lastLocation = lastLocation{
                let coordinate = _lastLocation.coordinate
                
                let location : CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let geocoder : CLGeocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (places: [CLPlacemark]?, error: Error?) in
                    if (error == nil){
                        if let _places = places {
                            if _places.count > 0{
                                let place = _places[0]
                                print("address: \(place.addressDictionary)")
                                if(place.name != nil){
                                    self.currentLocationLabel.text = place.name!
                                }
                            }else{
                                self.currentLocationLabel.text = "Dirección no encontrada"
                            }
                        } else {
                            self.currentLocationLabel.text = "Dirección no encontrada"
                        }
                        
                    }else{
                        self.currentLocationLabel.text = "Dirección no encontrada"
                    }
                }
                //currentLocationLabel.text = "Lat: \(coordinate.latitude), Long: \(coordinate.longitude)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case CLAuthorizationStatus.denied:
            break
        case CLAuthorizationStatus.authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0  // In meters.
            locationManager.startUpdatingLocation()
            break
        case CLAuthorizationStatus.authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0  // In meters.
            locationManager.startUpdatingLocation()
            break
        case CLAuthorizationStatus.notDetermined:
            break
        case CLAuthorizationStatus.restricted:
            break
        default:
            break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

