//
//  MyContainerVC.swift
//  IWMF
//
// This class is used for add container after Login screen.
//
//

import UIKit

class MyContainerVC: UIViewController {
    
    @IBOutlet weak var viewBackground : UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Structures.Constant.appDelegate.window?.bringSubviewToFront(viewBackground)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
