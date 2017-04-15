//
//  CommentVC.swift
//  MHealth
//
//  Created by Entisar on 3/6/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import Whisper
class CommentVC: UIViewController, NetworkCaller, UITextViewDelegate {
    
    @IBOutlet weak var patientCommentBox: UITextView!
    
    @IBOutlet weak var RecommendationBox: UITextView!
    
    @IBOutlet weak var replayOutlet: UIButton!
    
    var currentReport:PatientReport?
    var reportIndex:Int?
    
    var parentVC:ReportDetailsTVC?

    
    let networkManager:Networking = Networking()

    @IBAction func sendRecButton(sender: AnyObject) {
        
        if RecommendationBox.text == "" {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Recommendation Can't be empty", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.replayOutlet.enabled = false
        let parameter:NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(currentReport?.reportId, forKey: "reportId")
        parameter.setValue(RecommendationBox.text, forKey: "drcomment")
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            networkManager.AMJSONDictionary(Const.URLs.updateReportRec, httpMethod: "POST", jsonData: parameter, reqId: 1, caller: self)
        }
        
    }
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        
        print(resp)
        self.replayOutlet.enabled = true
        
        var alert:UIAlertController;
        if resp.valueForKey("status") != nil {
            if (resp.valueForKey("status") as! Bool) == true {
                
                alert = Alert().getAlert(NSLocalizedString("Updated", comment: ""), msg: NSLocalizedString("Profile is updated", comment: ""))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.currentReport?.drcomment = self.RecommendationBox.text
                updateReport()
                return
            }
            
        }
            
        alert = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't send Reply", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
    }

    func updateReport() {
        self.parentVC?.updateReportAtIndex(self.reportIndex!, reportID: (self.currentReport?.reportId)!, report: self.currentReport!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        patientCommentBox.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        patientCommentBox.layer.borderWidth = 0.8
        //The rounded corner part, where you specify your view's corner radius:
        patientCommentBox.layer.cornerRadius = 5;
        patientCommentBox.clipsToBounds = true;
        
        RecommendationBox.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        RecommendationBox.layer.borderWidth = 0.8
        //The rounded corner part, where you specify your view's corner radius:
        RecommendationBox.layer.cornerRadius = 5;
        RecommendationBox.clipsToBounds = true;
        
        self.patientCommentBox.text = self.currentReport?.comments
        self.RecommendationBox.text = self.currentReport?.drcomment
        RecommendationBox.delegate = self

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
