//
//  SetTimeViewController.swift
//  IMWF
//
//  This class is used for set Start Time or End Time of Check-in.
//
//

import UIKit

enum SetTime : Int{
    case StartTime = 1
    case EndTime = 2
}

protocol SetTimeProtocol{
    func selectedTimeByUser(date : NSDate, type : SetTime)
}

class SetTimeViewController: UIViewController {
    @IBOutlet weak var labelText: UILabel!
    var delegate : SetTimeProtocol!
    var hours : Int = 0
    var mins : Int = 0
    var setTimeScreen : Int = 0
    var setTime : SetTime!
    var endDate : NSDate!
        @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var createCustomLable: UILabel!
    @IBOutlet weak var checkInLable: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var btnBottomDone: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    //    var locale : NSLocale!
    @IBAction func btnBackPressed(sender: AnyObject) {
        backToPreviousScreen()
    }
    @IBAction func btnDonePressed(sender: AnyObject) {
        backToPreviousScreen()
        delegate?.selectedTimeByUser(datePickerView.date, type : self.setTime)
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startEndTime()
        self.createCustomLable.font = Utility.setFont()
        self.checkInLable.font = Utility.setNavigationFont()
        
        datePickerView.minimumDate = NSDate()
        
        if  self.setTime == .StartTime{
            self.labelText.text = NSLocalizedString(Utility.getKey("start_time"),comment:"")
            datePickerView.maximumDate = endDate
            datePickerView.date = NSDate()
        }else{
            self.labelText.text = NSLocalizedString(Utility.getKey("end_time"),comment:"")
            datePickerView.minimumDate = endDate
            datePickerView.date = endDate
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
        
        
        btnBottomDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        checkInLable.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            labelText.textAlignment = NSTextAlignment.Right
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            labelText.textAlignment = NSTextAlignment.Left
        }
        datePickerView.locale = NSLocale(localeIdentifier: "en")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //  MARK:- Done Button Method
    func startEndTime()
    {
        if  self.setTime == .StartTime
        {
            self.labelText.text = NSLocalizedString(Utility.getKey("start_time"),comment:"")
        }
        else
        {
            self.labelText.text = NSLocalizedString(Utility.getKey("end_time"),comment:"")
        }
    }
}
