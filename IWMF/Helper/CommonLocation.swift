//
//  CommonLocation.swift
//  IWMF
//
//  This class is used for fetch user's current location. If location services are not enabled than it retuns location of New York or User's last known location.
//
//

import UIKit
import CoreLocation

class CommonLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    func intializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.NotDetermined){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    func getUserCurrentLocation(){
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location : CLLocation = locations.first {
            if(location.horizontalAccuracy > 0){
                NSNotificationCenter.defaultCenter().postNotificationName(Structures.Constant.LocationUpdate, object:location)
                
                Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Latitude] = NSNumber(double: location.coordinate.latitude)
                Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Longitude] = NSNumber(double: location.coordinate.longitude)
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                
                locationManager.stopUpdatingLocation()
            }
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let location = Utility.getUsersLastKnownLocation() as CLLocation
        NSNotificationCenter.defaultCenter().postNotificationName(Structures.Constant.LocationUpdate, object:location)
    }
}
