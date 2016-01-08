 //
 //  CreateCustomCheckinViewController.swift
 //  IMWF
 //
 // This class is used for select custom frequency of Check-in.
 //
 //
 
 import UIKit
 
 protocol CreateCustomFrequencyProtocol{
    func customFrequencySelected(hours : Int, mins: Int)
 }
 
 class CreateCustomCheckinViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var createCustomLable: UILabel!
    @IBOutlet weak var checkInLable: UILabel!
    @IBOutlet weak var btnBottomDone: UIButton!
    @IBOutlet weak var pickerdata: UIPickerView!
    var delegate : CreateCustomFrequencyProtocol!
    var hours : Int = 0
    var mins : Int = 0
    var minsArray = [Int]()
    var hrsArray = [Int]()
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minsArray = [0,15,30,45]
        
        for hrs in 0...23
        {
            hrsArray.append(hrs)
        }
        
        createCustomLable.text=NSLocalizedString(Utility.getKey("Create custom"),comment:"")
        
        checkInLable.text=NSLocalizedString(Utility.getKey("check_in"),comment:"")
        
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        btnBottomDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        self.createCustomLable.font = Utility.setFont()
        self.checkInLable.font = Utility.setNavigationFont()
        
        pickerdata.selectRow(hours, inComponent: 0, animated: true)
        pickerdata.selectRow(mins, inComponent: 1, animated: true)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            createCustomLable.textAlignment = NSTextAlignment.Right
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            createCustomLable.textAlignment = NSTextAlignment.Left
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  MARK:- PickerView Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(component == 0){
            return hrsArray.count
        }
        return minsArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0
        {
            return String(hrsArray[row]) + " " + NSLocalizedString(Utility.getKey("hours"),comment:"")
        }
        
        if component == 1
        {
            return String(minsArray[row]) + " " + NSLocalizedString(Utility.getKey("minute"),comment:"")
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0)
        {
            hours = hrsArray[row]
        }
        else if(component == 1)
        {
            mins = minsArray[row]
        }
        
    }
    //  MARK:- Done Button Method
    @IBAction func customDone(sender: AnyObject) {
        delegate?.customFrequencySelected(hours, mins: mins)
        backToPreviousScreen()
    }
    
 }
