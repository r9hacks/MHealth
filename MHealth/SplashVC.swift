//
//  SplashVC.swift
//  MHealth
//
//  Created by trn24 on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
  
      @IBOutlet weak var arabicButton: UIButton!
    
    @IBOutlet weak var englishButton: UIButton!
    
    @IBAction func arabicAction(sender: AnyObject) {
        
        let lang:String = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.langKey) as! String
        if lang != "ar" {
            
            NSUserDefaults.standardUserDefaults().setValue("ar", forKey: Const.UserDefaultsKeys.langKey)
            NSUserDefaults.standardUserDefaults().setObject(["ar"], forKey: "AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //send alert to exit app
            let alertControlle:UIAlertController = UIAlertController(title: NSLocalizedString("Note", comment: ""), message: NSLocalizedString("To Apply Changes must restart the app", comment: ""), preferredStyle: .Alert)
            
            let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                let loginVC:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginVC
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            
            let actionExit:UIAlertAction =  UIAlertAction(title: NSLocalizedString("Exit Now", comment: ""), style: .Destructive, handler: { (UIAlertAction) in
                exit(0)
            })
            
            alertControlle.addAction(action)
            alertControlle.addAction(actionExit)
            self.presentViewController(alertControlle, animated: true, completion: nil)
            
        }else{
            let loginVC:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
    }
    
    @IBAction func EnglsihButton(sender: AnyObject) {
        
        let lang:String = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.langKey) as! String
        if lang != "en" {
            
            NSUserDefaults.standardUserDefaults().setValue("en", forKey: Const.UserDefaultsKeys.langKey)
            NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //send alert to exit app
            let alertControlle:UIAlertController = UIAlertController(title: NSLocalizedString("Note", comment: ""), message: NSLocalizedString("To Apply Changes must restart the app", comment: ""), preferredStyle: .Alert)
            
            let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                let loginVC:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginVC
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            
            let actionExit:UIAlertAction =  UIAlertAction(title: NSLocalizedString("Exit Now", comment: ""), style: .Destructive, handler: { (UIAlertAction) in
                exit(0)
            })
            
            alertControlle.addAction(action)
            alertControlle.addAction(actionExit)
            self.presentViewController(alertControlle, animated: true, completion: nil)
            
        }else{
            let loginVC:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lang:String? = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.langKey) as? String
        if (lang != nil) {
//            let loginVC:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginVC
//            self.navigationController?.pushViewController(loginVC, animated: true)
        }else{
            NSUserDefaults.standardUserDefaults().setValue("en", forKey: Const.UserDefaultsKeys.langKey)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
