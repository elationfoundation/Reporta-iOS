//
//  MediaPickerViewController.swift
//  IWMF
//
//  This class is used for capture media like Picture, Video and Audio.
//

import UIKit
import MobileCoreServices
import AVFoundation

enum MediaFor : Int{
    case CheckIn = 1
    case Alert = 2
}

protocol MediaDetailProtocol{
    func addMedia(mediaObject : Media)
}

class MediaPickerViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var btncamera: UIButton?
    @IBOutlet weak var btnvideo: UIButton?
    @IBOutlet weak var btnaudio: UIButton?
    @IBOutlet weak var btndone: UIButton?
    @IBOutlet weak var mainImage: UIImageView?
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var btnStartStop: UIButton!
    @IBOutlet weak var lblTimerText: UILabel!
    var isImageLoaded : Bool = false
    var isVideoLoaded : Bool = false
    var isAudioLoaded : Bool = false
    var objects = NSMutableArray()
        var videourl : NSURL?
    var player : AVPlayer?
    var playerlayer : AVPlayerLayer?
    var audioRecorder : AVAudioRecorder?
    var media : Media!
    var delegate : MediaDetailProtocol!
    var mediaFor : MediaFor = .Alert
    var audioPlayer : AVAudioPlayer?
    var isRecording : Bool!
    var Audiourl : NSURL?
    var meterTimer:NSTimer!
    var rec_time: Double!
    var interval = NSTimeInterval()
    var theDateAudio : NSString!
    var dateAudio : NSDate!
    var savedAudioPath : String!
    var buttonContainerOriginY :CGFloat!
    var soundFilePath : String!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:UIStatusBarAnimation.None)
        
        
        
        self.btndone?.hidden = true
        mainImage?.contentMode = UIViewContentMode.ScaleAspectFit
        self.btnStartStop?.hidden = true
        self.lblTimerText?.hidden=true
        buttonContainerOriginY=0
        self.btndone?.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        Structures.Constant.appDelegate.hideSOSButton()
        
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopRecordingAudio(false)
    }
    deinit {
        self.btncamera = nil
        self.btnaudio = nil
        self.btnaudio = nil
        self.btndone = nil;
        self.mainImage = nil;
        self.btnStartStop=nil;
        
    }
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
        }
    }
    func isAnyThingLoaded(){
        var title = ""
        var isLoaded : Bool = false
        if isImageLoaded{
            title = NSLocalizedString(Utility.getKey("save_captured_image"),comment:"")
            isLoaded = true
        }else if isVideoLoaded{
            title = NSLocalizedString(Utility.getKey("save_captured_video"),comment:"")
            isLoaded = true
        }else if isAudioLoaded{
            title = NSLocalizedString(Utility.getKey("save_captured_audio"),comment:"")
            isLoaded = true
        }
        if isLoaded{
            
            let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("save"),comment:"") , style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if self.isImageLoaded{
                    self.saveImage()
                    self.isImageLoaded = false
                }else if self.isVideoLoaded{
                    self.saveVideo()
                    self.isVideoLoaded = false
                }else if self.isAudioLoaded{
                    self.saveAudio()
                    self.isAudioLoaded = false
                }
                
                if self.btncamera!.selected{
                    self.captureMedia(UIImagePickerControllerCameraCaptureMode.Photo)
                }else if self.btnvideo!.selected{
                    self.captureMedia(UIImagePickerControllerCameraCaptureMode.Video)
                }else if self.btnaudio!.selected{
                    
                }
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("discard"),comment:""), style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.btndone?.hidden = true
                if self.isImageLoaded{
                    self.isImageLoaded = false
                }else if self.isVideoLoaded{
                    self.isVideoLoaded = false
                }else if self.isAudioLoaded{
                    self.isAudioLoaded = false
                    
                    CommonUnit.deleteSingleAudioFile(self.soundFilePath as String)
                    
                }
                
                if self.btncamera!.selected{
                    self.captureMedia(UIImagePickerControllerCameraCaptureMode.Photo)
                }else if self.btnvideo!.selected{
                    self.captureMedia(UIImagePickerControllerCameraCaptureMode.Video)
                }else if self.btnaudio!.selected{
                    
                }
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            if self.btncamera!.selected{
                self.captureMedia(UIImagePickerControllerCameraCaptureMode.Photo)
            }else if self.btnvideo!.selected{
                self.captureMedia(UIImagePickerControllerCameraCaptureMode.Video)
            }else if self.btnaudio!.selected{
                
            }
        }
    }
    // MARK: - UIButton Events
    @IBAction func captureButtonClicked(sender: UIButton) {
        self.btncamera?.selected = false
        self.btnaudio?.selected = false
        self.btnvideo?.selected = false
        
        self.btnStartStop?.hidden=true
        self.lblTimerText?.hidden=true
        
        switch(sender){
        case btncamera!:
            self.btncamera?.selected = true
            
            if audioRecorder?.recording == true
            {
                stopRecordingAudio(false)
            }
            if buttonContainerOriginY>0 && buttonContainerOriginY != 0
            {
                self.buttonContainerView.frame=CGRectMake(self.buttonContainerView.frame.origin.x, buttonContainerOriginY, self.buttonContainerView.frame.size.width,self.buttonContainerView.frame.size.height)
                buttonContainerOriginY=0
            }
            
        case btnaudio!:
            self.btnaudio?.selected = true
            if buttonContainerOriginY==0
            {
                buttonContainerOriginY=self.buttonContainerView.frame.origin.y
            }
            captureAudio()
        case btnvideo!:
            self.btnvideo?.selected = true
            if audioRecorder?.recording == true
            {
                stopRecordingAudio(false)
            }
            if buttonContainerOriginY>0 && buttonContainerOriginY != 0
            {
                self.buttonContainerView.frame=CGRectMake(self.buttonContainerView.frame.origin.x, buttonContainerOriginY, self.buttonContainerView.frame.size.width,self.buttonContainerView.frame.size.height)
                buttonContainerOriginY=0
            }
            
        default:
            break;
        }
        isAnyThingLoaded()
    }
    @IBAction func doneClicked(sender: UIButton) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        if isImageLoaded{
            self.saveImage()
            self.navigationController?.popViewControllerAnimated(true)
        }else if isVideoLoaded{
            self.saveVideo()
            self.navigationController?.popViewControllerAnimated(true)
        }else if isAudioLoaded{
            self.saveAudio()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func cancelCLicked(sender: UIButton) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        backToPreviousScreen()
    }
    // MARK: - capture from camera
    func captureMedia(mode: UIImagePickerControllerCameraCaptureMode)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.allowsEditing = false
            picker.videoQuality = UIImagePickerControllerQualityType.TypeLow
            
            Structures.Constant.appDelegate.hideSOSButton()
            
            if(mode == UIImagePickerControllerCameraCaptureMode.Video)
            {
                Structures.Constant.appDelegate.hideSOSButton()
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.videoMaximumDuration = 15;
            }
            else
            {
                picker.mediaTypes = [kUTTypeImage as String]
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    // MARK: - UIImagePickerController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if((info[UIImagePickerControllerMediaType] as! String == kUTTypeImage as String)){
            
            
            mainImage?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            mainImage?.contentMode = UIViewContentMode.ScaleAspectFit
            isImageLoaded = true
            videourl = nil
            removeVideoFile()
        }else
        {
            mainImage?.image = nil
            videourl = info[UIImagePickerControllerMediaURL] as? NSURL
            isVideoLoaded = true
            addVideoFile()
        }
        self.btndone?.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func saveImage(){
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy||HH:mm:SS"
        let date = NSDate()
        let theDate = dateFormat.stringFromDate(date)
        let savedImagePath : String = String(format: "%@.jpg", theDate)
        CommonUnit.storeImage(mainImage?.image, withName: savedImagePath, inDirectory: "/Media/", encryptionKey: Structures.Constant.appDelegate.prefrence.appEncryptionKey as String)
        
        
        let  media = Media()
        media.name =  String(format: "%@.jpg", theDate)
        media.mediaType = MediaType.Image
        media.time = date
        if  mediaFor == MediaFor.Alert
        {
            media.noficationType = NotificationType.Alert
        }
        else if  mediaFor == MediaFor.CheckIn
        {
            media.noficationType = NotificationType.CheckIn
        }
        delegate?.addMedia(media)
        
    }
    func saveVideo(){
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy||HH:mm:SS"
        let date = NSDate()
        let theDate = dateFormat.stringFromDate(date)
        let savedVideoPath : String = String(format: "%@.mp4", theDate)
        CommonUnit.storeVideo(savedVideoPath, urlstring: videourl?.path, dirName: "/Media/", encryptionKey: Structures.Constant.appDelegate.prefrence.appEncryptionKey as String)
        
        let  media = Media()
        media.name =  String(format: "%@.mp4", theDate)
        media.mediaType = MediaType.Video
        media.time = date
        if  mediaFor == MediaFor.Alert
        {
            media.noficationType = NotificationType.Alert
        }
        else if  mediaFor == MediaFor.CheckIn
        {
            media.noficationType = NotificationType.CheckIn
        }
        delegate?.addMedia(media)
    }
    func saveAudio()
    {
        
        Audiourl = NSURL(fileURLWithPath: soundFilePath)
        CommonUnit.storeAudio(savedAudioPath, urlstring:soundFilePath, dirName: "/Media/", encryptionKey: Structures.Constant.appDelegate.prefrence.appEncryptionKey as String)
        CommonUnit.deleteSingleAudioFile(self.soundFilePath as String)
        
        let  media = Media()
        media.name =  String(format: "%@.caf", theDateAudio)
        media.mediaType = MediaType.Audio
        media.time = dateAudio
        if  mediaFor == MediaFor.Alert
        {
            media.noficationType = NotificationType.Alert
        }
        else if  mediaFor == MediaFor.CheckIn
        {
            media.noficationType = NotificationType.CheckIn
        }
        delegate?.addMedia(media)
    }
    //MARK:-
    func addVideoFile()
    {
        self.player = AVPlayer(URL: self.videourl!)
        self.playerlayer = AVPlayerLayer(player: self.player)
        self.playerlayer!.videoGravity = AVLayerVideoGravityResizeAspect
        self.playerlayer!.frame = self.mainImage!.bounds
        self.mainImage?.layer.addSublayer(self.playerlayer!)
        
    }
    func removeVideoFile()
    {
        self.playerlayer?.removeFromSuperlayer()
        self.player = nil
        self.playerlayer = nil
    }
    // MARK: - capture audio
    //Capture view setup
    func captureAudio()
    {
        removeVideoFile()
        self.mainImage?.image = nil
        
        btndone?.hidden = true
        self.buttonContainerView.translatesAutoresizingMaskIntoConstraints = true
        
        if buttonContainerOriginY == self.buttonContainerView.frame.origin.y
        {
            self.buttonContainerView.frame=CGRectMake(self.buttonContainerView.frame.origin.x, self.buttonContainerView.frame.origin.y-40, self.buttonContainerView.frame.size.width,self.buttonContainerView.frame.size.height)
        }
        else
        {
            self.buttonContainerView.frame=CGRectMake(self.buttonContainerView.frame.origin.x, self.buttonContainerView.frame.origin.y, self.buttonContainerView.frame.size.width,self.buttonContainerView.frame.size.height)
        }
        self.lblTimerText.text="00:00:00"
        self.btnStartStop.addTarget(self, action: "recordStartStopAudio", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnStartStop.selected = false
        self.lblTimerText?.hidden=false
        self.btnStartStop?.hidden=false
    }
    //setup to record and save path of audio
    func prepareToRecord()
    {
        let recorderSettings = [AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue)),
            AVEncoderBitRateKey : NSNumber(int: Int32(128000)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVSampleRateKey : NSNumber(float: Float(44100.0))]
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir: AnyObject=dirPaths[0]
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy||HH:mm:SS"
        dateAudio = NSDate()
        theDateAudio = dateFormat.stringFromDate(dateAudio)
        savedAudioPath = String(format: "%@.caf", theDateAudio)
        
        soundFilePath = docsDir.stringByAppendingPathComponent(savedAudioPath)
        Audiourl = NSURL(fileURLWithPath: soundFilePath)
        do {
            audioRecorder = try AVAudioRecorder(URL:Audiourl!, settings:recorderSettings)
            audioRecorder?.delegate=self
        } catch let error1 as NSError {
            SVProgressHUD.showErrorWithStatus(error1.description)
            audioRecorder = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder?.prepareToRecord()
        } catch let error1 as NSError {
            SVProgressHUD.showErrorWithStatus(error1.description)
        }
        
    }
    //Start or Stop Audio recording
    func recordStartStopAudio()
    {
        let audioSession = AVAudioSession.sharedInstance()
        if (audioSession.respondsToSelector("requestRecordPermission:")) {
            
            audioSession.requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    do{
                        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        
                        if self.isRecording != true
                        {
                            self.prepareToRecord()
                        }
                        
                        if self.audioRecorder?.recording == false
                        {
                            self.isRecording = true
                            self.btnStartStop.selected = true
                            self.audioRecorder?.record()
                            
                            self.rec_time = 0
                            self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                target:self,
                                selector:"updateAudioMeter",
                                userInfo:nil,
                                repeats:true)
                        }
                        else if self.isRecording == true
                        {
                            self.stopRecordingAudio(true)
                        }
                    } catch let error1 as NSError {
                        SVProgressHUD.showErrorWithStatus(error1.description)
                    }
                }
            })
        }
    }
    
    //timer method for stop recording after end of timer and update timer label
    func updateAudioMeter()
    {
        if audioRecorder?.recording == true
        {
            if (rec_time >= 60.0) {
                stopRecordingAudio(true)
                return;
            }
            
            rec_time = rec_time + 0.1;
            interval=rec_time
            
            let date = NSDate(timeIntervalSince1970:interval)
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en")
            formatter.dateFormat = "mm:ss.SS" //HH:mm:ss
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            let s = formatter.stringFromDate(date)
            self.lblTimerText.text=s
        }
    }
    //Stop recording method
    func stopRecordingAudio(play: Bool)
    {
        isRecording = false
        self.btnStartStop.selected = false
        if audioRecorder?.recording == true
        {
            meterTimer.invalidate()
            audioRecorder?.stop()
            if buttonContainerOriginY>0 && buttonContainerOriginY != 0
            {
                self.buttonContainerView.frame=CGRectMake(self.buttonContainerView.frame.origin.x, buttonContainerOriginY, self.buttonContainerView.frame.size.width,self.buttonContainerView.frame.size.height)
                buttonContainerOriginY=0
            }
            self.btndone?.hidden = false
            btnStartStop.hidden = true
            isAudioLoaded = true
            
        }
    }
}

