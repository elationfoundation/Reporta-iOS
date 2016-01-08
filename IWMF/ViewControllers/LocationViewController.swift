//
//  LocationViewController.swift
//  IWMF
//
//  This class is created for display location in Check-in and Alert view.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

enum LocationNavigationTitle : Int{
    case CheckIn = 0
    case Alert = 1
}

protocol LocationDetailProtocol{
    func locationTextChanged(changedText : NSString, location : CLLocation)
}

class LocationViewController: UIViewController, LocationChangedProtocol, LocationTextChangeProtocol {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnBarCancel: UIBarButtonItem!
    @IBOutlet weak var btnBarDone: UIBarButtonItem!
    @IBOutlet weak var tblView: UITableView!
        var arrLocations = NSMutableArray()
    var arrTempLocations = NSMutableArray()
    var userLocationString : NSString = ""
    var userLocation : CLLocation!
    var pinLocation : CLLocation!
    @IBOutlet var toolbar : UIToolbar!
    var delegate : LocationDetailProtocol?
    var tableFooteHeight : CGFloat = 60
    var footerCell : LocationTextTablviewCell!
    var lastContentOffset : CGFloat!
    var activeTextview : UITextView!
    @IBOutlet weak var lableTitle: UILabel!
    var changeTitle : Int!
    var isKeyboardOpen : Bool!
    override func viewDidLoad()
    {
        tblView.hidden = true
        
        arrLocations = NSMutableArray()
        arrTempLocations = NSMutableArray()
        lableTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
       
        self.lableTitle.font = Utility.setNavigationFont()
        if(CommonUnit.isIphone4()){
            self.tableFooteHeight = 60
        }
        else if(CommonUnit.isIphone5()){
            self.tableFooteHeight = 80
        }
        else if(CommonUnit.isIphone6()){
            self.tableFooteHeight = 110
        }
        else if(CommonUnit.isIphone6plus()){
            self.tableFooteHeight = 110
        }
        
        switch changeTitle
        {
        case LocationNavigationTitle.Alert.rawValue :
            self.lableTitle.text = NSLocalizedString(Utility.getKey("alerts"),comment:"")
            
        case LocationNavigationTitle.CheckIn.rawValue :
            self.lableTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
            
        default :
            self.lableTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
        }
        
        pinLocation = userLocation
        lastContentOffset = 0.0
        self.isKeyboardOpen = false
        
        //Set Header of UITableview
        Structures.Constant.appDelegate.headerCell.coordinates = CLLocationCoordinate2D(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)
        Structures.Constant.appDelegate.headerCell.intializeMapView()
        Structures.Constant.appDelegate.headerCell.delegate = self
        if Structures.Constant.appDelegate.isArabic == true
        {
            Structures.Constant.appDelegate.headerCell.lblMapText.textAlignment = NSTextAlignment.Right
        }
        else
        {
            Structures.Constant.appDelegate.headerCell.lblMapText.textAlignment = NSTextAlignment.Left
        }
        if  self.userLocationString.length == 0
        {
            Structures.Constant.appDelegate.headerCell.getAddressCurrentLocation(self.pinLocation)
        }
        var intHeight = 0 as CGFloat
        if(CommonUnit.isIphone4())
        {
            intHeight = UIScreen.mainScreen().bounds.size.width - 70
        }
        else
        {
            intHeight = UIScreen.mainScreen().bounds.size.width
        }
        
        var fr : CGRect = Structures.Constant.appDelegate.headerCell.frame
        fr.size.height = intHeight
        Structures.Constant.appDelegate.headerCell.frame = fr
        tblView.tableHeaderView = Structures.Constant.appDelegate.headerCell
        self.automaticallyAdjustsScrollViewInsets = false
        tblView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
     
        self.tblView.registerNib(UINib(nibName: "MapTableviewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MapTableviewCellIdentifier")
        self.tblView.registerNib(UINib(nibName: "LocationTextTablviewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LocationFooterCellIdentifier")
        self.tblView.registerNib(UINib(nibName: "LocationDetailCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LocationDetailCellIdentifier")
        tblView.rowHeight =  UITableViewAutomaticDimension

        
        self.arrTempLocations.addObject(["name":Structures.AppKeys.LookingLocations] as NSDictionary)
        
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        SVProgressHUD.show()
        registerForKeyboardNotifications()
        super.viewWillAppear(animated)
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
        }
        else
        {
            btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("done"),comment:"")
        }
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.getNearByPlacesData(self.userLocation)
        })
    }
    override func viewDidDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    func registerForKeyboardNotifications()
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,  selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification,  object: nil)
        notificationCenter.addObserver(self,  selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification : NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tblView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.size.height , 0.0)
                self.tblView.scrollIndicatorInsets = self.tblView.contentInset
                var rect : CGRect = self.tblView.frame
                rect.size.height -= keyboardSize.size.height
                self.isKeyboardOpen = true
                let newContentOffset : CGPoint = CGPointMake(0, self.tblView.contentSize.height - self.footerCell.textView.bounds.size.height )
                self.lastContentOffset = newContentOffset.y
                self.tblView.setContentOffset(newContentOffset, animated: false)
            })
        }
    }
    func keyboardWillHide(notification : NSNotification)
    {
        if  self.isKeyboardOpen == true
        {
            self.isKeyboardOpen = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tblView.contentInset = UIEdgeInsetsZero
                self.tblView.scrollIndicatorInsets = UIEdgeInsetsZero
                self.view.endEditing(true)
                self.tblView.setContentOffset(CGPointZero, animated: true)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                })
            })
        }
    }
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            self.delegate?.locationTextChanged(self.userLocationString, location: self.userLocation)
            backToPreviousScreen()
        }
        else
        {
            backToPreviousScreen()
        }
    }
    @IBAction func btnToolbarDoneClicked(sender:AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.view.endEditing(true)
                self.tblView.setContentOffset(CGPointZero, animated: true)
                self.tblView.reloadData()
                SVProgressHUD.dismiss()
            })
        }
        else
        {
            btnBarDoneClick()
        }
    }
    func btnBarDoneClick()
    {
        
        self.view.endEditing(true)
        self.tblView.setContentOffset(CGPointZero, animated: true)
        let finalText : NSString = Utility.condenseWhitespace(footerCell.textView.text)
        if finalText.length > 0 {
            if finalText != self.userLocationString{
                self.userLocationString = finalText
                self.userLocation = CLLocation(latitude: 0.0, longitude: 0.0)
                let tempAdd = finalText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, finalText.length))
                var strAddress = tempAdd as String
                strAddress = strAddress.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(strAddress)&key=\(Utility.getDecryptedString(Structures.AppKeys.GooglePlaceAPIKey))")
                let request1: NSURLRequest = NSURLRequest(URL: url!)
                let queue:NSOperationQueue = NSOperationQueue()
                if  Utility.isConnectedToNetwork()
                {
                    NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        if error != nil
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.dismiss()
                            })
                            
                            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("location_manualy"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                            
                        }
                        else
                        {
                            let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                            if  jsonResult[Structures.Constant.Status] as! NSString == "OK"{
                                let Results : NSArray = jsonResult["results"] as! NSArray
                                if  Results.count > 0{
                                    let innerDict : NSDictionary = Results[0] as! NSDictionary
                                    let geometry : NSDictionary = innerDict["geometry"] as! NSDictionary
                                    let location : NSDictionary = geometry[Structures.Alert.Location] as! NSDictionary
                                    let locate : CLLocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                                    self.userLocationString = finalText
                                    self.userLocation = locate
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.tblView.reloadData()
                                        SVProgressHUD.dismiss()
                                    })
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tblView.reloadData()
                                    SVProgressHUD.dismiss()
                                })
                                
                                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                            }
                        }
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tblView.reloadData()
                        SVProgressHUD.dismiss()
                    })
                    
                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                }
            }else{
                self.delegate?.locationTextChanged(self.userLocationString, location: self.userLocation)
                backToPreviousScreen()
            }
        }
        
    }
    @IBAction func btnToolbarCancelClicked(sender:AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBarDoneClick()
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.view.endEditing(true)
                self.tblView.setContentOffset(CGPointZero, animated: false)
                self.tblView.reloadData()
                SVProgressHUD.dismiss()
            })
        }
    }
    @IBAction func btnDoneClicked(sender: AnyObject) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            backToPreviousScreen()
        }
        else
        {
            self.delegate?.locationTextChanged(self.userLocationString, location: self.userLocation)
            backToPreviousScreen()
        }
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrLocations.count > 0
        {
            return self.arrLocations.count
        }else{
            return self.arrTempLocations.count
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 65
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = "LocationDetailCellIdentifier"
        if let cell: LocationDetailCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? LocationDetailCell
        {
            if arrLocations.count > 0
            {
                let dictResult : NSDictionary = self.arrLocations[indexPath.row] as! NSDictionary
                let value = dictResult["name"] as! NSString!
                cell.lblTitle.text = value as String
                cell.lblTitle.numberOfLines = 1
                
                let geometry : NSDictionary = dictResult["geometry"] as! NSDictionary
                let location : NSDictionary = geometry[Structures.Alert.Location] as! NSDictionary
                let placeLoc = CLLocation(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                let distance : CLLocationDistance = self.pinLocation.distanceFromLocation(placeLoc)
                let miles = Float(Double(distance*3.28084)/5280)
                if miles > 1.0{
                    cell.lblSubTitle?.text = String(format: NSLocalizedString(Utility.getKey("dist_mi"),comment:""), miles)
                }else{
                    cell.lblSubTitle?.text = String(format: NSLocalizedString(Utility.getKey("dist_ft"),comment:""), (distance*3.28084))
                }
                cell.selectionStyle = .Gray
                cell.userInteractionEnabled = true
                cell.lblSubTitle?.hidden = false
            }
            else
            {
                let dictResult : NSDictionary = self.arrTempLocations[indexPath.row] as! NSDictionary
                let value = dictResult["name"] as! NSString!
                cell.lblTitle.text = value as String
                cell.lblTitle.numberOfLines = 1
                cell.lblSubTitle?.hidden = true
                cell.selectionStyle = .None
                cell.userInteractionEnabled = false
            }
            
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Right
                cell.lblSubTitle?.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Left
                cell.lblSubTitle?.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerCell = tableView.dequeueReusableCellWithIdentifier("LocationFooterCellIdentifier") as! LocationTextTablviewCell
        footerCell.delegate = self
        if self.userLocationString.length>0
        {
            footerCell.textView.text = self.userLocationString as String
            footerCell.textView.textColor = UIColor.blackColor()
        }
        else
        {
            footerCell.textView.text = NSLocalizedString(Utility.getKey("enter_location_manually"),comment:"")
            footerCell.textView.textColor = UIColor.lightGrayColor()
        }
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            footerCell.textView.textAlignment = NSTextAlignment.Right
        }
        else
        {
            footerCell.textView.textAlignment = NSTextAlignment.Left
        }
        return footerCell
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return tableFooteHeight
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if self.arrLocations.count > 0
        {
            if self.arrLocations[indexPath.row]["name"] != nil
            {
                let name = self.arrLocations[indexPath.row]["name"] as! NSString!
                let dictResult = self.arrLocations[indexPath.row] as! NSDictionary
                let vicinity = dictResult["vicinity"] as! NSString!
                self.userLocationString = "\(name) , \(vicinity)"
                let geometry : NSDictionary = dictResult["geometry"] as! NSDictionary
                let location : NSDictionary = geometry[Structures.Alert.Location] as! NSDictionary
                self.userLocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
    func getPlaceDetailFromPlaceID(placeID : NSString){
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(Utility.getDecryptedString(Structures.AppKeys.GooglePlaceAPIKey))")
        let request1: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
        if  Utility.isConnectedToNetwork(){
            let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            let jsonResult: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
            if  jsonResult[Structures.Constant.Status] as! NSString == "OK"
            {
                let Results : NSDictionary = jsonResult["result"] as! NSDictionary!
                self.userLocationString = Results["formatted_address"] as! NSString!
                let geometry : NSDictionary = Results["geometry"] as! NSDictionary
                let location : NSDictionary = geometry[Structures.Alert.Location] as! NSDictionary
                self.userLocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }
            else
            {
                self.userLocationString = "Some Error! Please try again later."
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }
        }else{
            
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    //MARK:- Location Method
    func getNearByPlacesData(location : CLLocation){
        
        self.arrTempLocations = NSMutableArray()
        self.arrTempLocations.addObject(["name":Structures.AppKeys.LookingLocations] as NSDictionary)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tblView.reloadData()
            self.tblView.hidden  = false
            SVProgressHUD.dismiss()
        })
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&key=\(Utility.getDecryptedString(Structures.AppKeys.GooglePlaceAPIKey))&radius=5000")
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 10
        let queue : NSOperationQueue = NSOperationQueue()
        
        if  Utility.isConnectedToNetwork(){
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if error != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SVProgressHUD.dismiss()
                    })
                    
                    
                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("location_manualy"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    
                    
                }else{
                    let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    if(jsonResult.valueForKey(Structures.Constant.Status) as! NSString).isEqualToString("OK"){
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.showGoogleNearByResults(jsonResult["results"]!)
                        })
                    }else{
                        self.arrTempLocations = NSMutableArray()
                        self.arrTempLocations.addObject(["name": Structures.AppKeys.NoLocations] as NSDictionary)
                        dispatch_async(dispatch_get_main_queue(),
                            { () -> Void in
                                self.tblView.reloadData()
                                self.tblView.hidden  = false
                                SVProgressHUD.dismiss()
                        })
                    }
                }
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tblView.reloadData()
                self.tblView.hidden = false
                SVProgressHUD.dismiss()
            })
            
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            
        }
    }
    func showGoogleNearByResults(arrayLocations : AnyObject){
        
        let arr : [AnyObject] = arrayLocations as! NSArray as [AnyObject]
        let arrMutTemp = NSMutableArray(array: arr)
        
        arrMutTemp.sortUsingComparator{ (dictA  , dictb ) -> NSComparisonResult in
            let geo1 : NSDictionary = dictA["geometry"] as! NSDictionary
            let loc1 : NSDictionary = geo1[Structures.Alert.Location] as! NSDictionary
            let clloc1 = CLLocation(latitude: loc1["lat"] as! CLLocationDegrees, longitude: loc1["lng"] as! CLLocationDegrees)
            let dist1 : CLLocationDistance = self.pinLocation.distanceFromLocation(clloc1)
            
            let geo2 : NSDictionary = dictb["geometry"] as! NSDictionary
            let loc2 : NSDictionary = geo2[Structures.Alert.Location] as! NSDictionary
            let clloc2 = CLLocation(latitude: loc2["lat"] as! CLLocationDegrees, longitude: loc2["lng"] as! CLLocationDegrees)
            let dist2 : CLLocationDistance = self.pinLocation.distanceFromLocation(clloc2)
            
            if dist1 < dist2{
                return .OrderedAscending
            }else if dist1 > dist2{
                return .OrderedDescending
            }else{
                return .OrderedSame
            }
        }
        for location in arrMutTemp{
            if location["name"] != nil && location["geometry"] != nil && location[Structures.Alert.Location] != nil && location["lat"] != nil && location["lng"] != nil  {
                self.arrLocations.addObject(location as! NSDictionary)
            }
        }
        dispatch_async(dispatch_get_main_queue(),{ () -> Void in
            self.tblView.reloadData()
            self.tblView.hidden  = false
            SVProgressHUD.dismiss()
        })
    }
    func userChangedTheLocation(location : CLLocation, locationString : NSString){
        self.userLocationString = locationString
        self.userLocation = location
        self.pinLocation = location
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.getNearByPlacesData(location)
        })
    }
    // MARK : Location TextView Start Editing Delegate Method
    func locationTextViewStartEditing(textView : UITextView)
    {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
        }
        else
        {
            btnDone.hidden = true
        }
        
        textView.inputAccessoryView = toolbar
        
    }
    func locationTextViewEndEditing(textView : UITextView){
        let text : NSString = NSString(format: "%@", textView.text)
        if  text.length == 0
        {
        }
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = false
        }
        else
        {
            btnDone.hidden = false
        }
    }
}