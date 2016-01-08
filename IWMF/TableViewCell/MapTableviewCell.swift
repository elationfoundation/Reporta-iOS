//
//  MapTableviewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol LocationChangedProtocol{
    func userChangedTheLocation(location : CLLocation, locationString : NSString)
}

class MapTableviewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {    
    @IBOutlet weak var mapView: MKMapView!    
    @IBOutlet weak var lblMapText: UILabel!
    var delegate : LocationChangedProtocol?
    var locationManager: CLLocationManager?
    var coordinates : CLLocationCoordinate2D!
    var userAnnotation : MKPointAnnotation!
    override func awakeFromNib() {
        
    super.awakeFromNib()
        lblMapText.text=NSLocalizedString(Utility.getKey("drag_pin"),comment:"")
    }    
    func intializeMapView(){
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(self.coordinates, theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = self.coordinates
        userAnnotation.title = "Current Location"
        mapView.addAnnotation(userAnnotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !annotation.isKindOfClass(MKUserLocation){
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("UserLocationPinIdentifier")
            if pin == nil {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "UserLocationPinIdentifier")
            }
            else
            {
                pin!.annotation = annotation;
            }
            pin!.draggable = true
            pin!.canShowCallout = false
            return pin;
        }
        return nil
    }    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == MKAnnotationViewDragState.Ending || newState == MKAnnotationViewDragState.Canceling{
            let location = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
            getAddressCurrentLocation(location)
        }
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
    func getAddressCurrentLocation(location : CLLocation){
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.coordinate.latitude),\(location.coordinate.longitude)&key=\(Utility.getDecryptedString(Structures.AppKeys.GooglePlaceAPIKey))")
        let request1: NSURLRequest = NSURLRequest(URL: url!)
        let queue:NSOperationQueue = NSOperationQueue()
        if  Utility.isConnectedToNetwork(){
            NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if error != nil{
                }else{
                    let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    if  jsonResult[Structures.Constant.Status] as! NSString == "OK"{
                        let Results : NSArray = jsonResult["results"] as! NSArray
                        if  Results.count > 0{
                            let innerDict : NSDictionary = Results[0] as! NSDictionary
                            self.delegate?.userChangedTheLocation(location, locationString: innerDict["formatted_address"] as! NSString!)
                        }
                    }
                }
            })
        }
    }
}