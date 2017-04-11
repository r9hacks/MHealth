//
//  ProfileVC.swift
//  MHealth
//
//  Created by trn24 on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import Whisper
import SwiftSpinner


class ProfileVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,NetworkCaller {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var specialtyLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateProfileButton: UIButton!

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    let networkManager: Networking = Networking()
    var updatedDoctor:Doctor?

    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.drProfile)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.doctorID)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    @IBAction func btnEdit(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Upload Image", message: "Choose one of the two options", preferredStyle: .ActionSheet)

        let CameraRollAction = UIAlertAction(title: "Camera roll", style: .Default, handler: {(action: UIAlertAction) -> Void in
            print("Camera Roll")
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        })

        let CameraAction = UIAlertAction(title: "Take photo", style: .Default, handler: {(action: UIAlertAction) -> Void in
             print("Camera ")
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
             print("Cancel")
        })
        
        alertController.addAction(CameraAction)
        alertController.addAction(CameraRollAction)
        alertController.addAction(CancelAction)
        
        self.presentViewController(alertController, animated: true, completion: { _ in })

        print ("Button clicked")
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Encode base64
        let imageData = UIImagePNGRepresentation(image)
        //var base64 = dataImage.base64EncodedStringWithOptions(NSDataBase64Encoding64CharacterLineLength)
        let strBase64:String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        //Decode
       // let dataDecoded:NSData = NSData(base64EncodedString: strBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!

        
        photo.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ProfileVC.image(_:didFinishSavingWithError:contextInfo:)), nil)

        let reach = Reach()
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Uploading...", comment: ""))
            
            
           // networkManager.AMJSONDictionary(Const.URLs.Doctor, httpMethod: "POST", jsonData: drDict, reqId: 1, caller: self)
            let params:[String:AnyObject] = ["appID": "doctor" , "imgData": strBase64]

            networkManager.AMPostDictData(Const.URLs.UploadImage, params: params, reqId: 1, caller: self)
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
    }
    
    func loadImage(u:String) {
        if Validator().verifyUrl(u) == false{
            return
        }
        let url:NSURL = NSURL(string: u)!
        
        let data:NSData = NSData(contentsOfURL: url)!
        
        let doctorPhoto:UIImage? = UIImage(data: data)
        if doctorPhoto != nil {
            self.photo.image = doctorPhoto
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Customization().addUnderLineToLabel(nameLabel)
        Customization().addUnderLineToLabel(specialtyLabel)
        Customization().addUnderLineToLabel(locationLabel)
        Customization().addUnderLineToLabel(emailLabel)
        Customization().addUnderLineToLabel(phoneLabel)
        
        // Do any additional setup after loading the view.
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber
        
        //loadImage(currentDoctor.imageUrl)
        //self.performSelectorInBackground(Selector(loadImage(currentDoctor.imageUrl)), withObject: currentDoctor.imageUrl)
        //performSelector(#selector(loadImage), withObject: currentDoctor.imageUrl)
        
        
        let url:NSURL = NSURL(string: currentDoctor.imageUrl)!
        self.photo.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
            
        
        
        
        self.photo.layer.borderWidth = 2.0
        self.photo.layer.masksToBounds = true
        self.photo.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        self.photo.layer.cornerRadius = self.photo.frame.size.height/2
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        SwiftSpinner.hide()

        if reqId == 1 {
            if (resp.valueForKey("errorMsgEn") != nil) {
                let result:String = resp.valueForKey("errorMsgEn") as! String
                if result.lowercaseString == "Done".lowercaseString{
                    let alertControlle:UIAlertController = UIAlertController(title: "Image Upload", message: "Upload successful", preferredStyle: .Alert)
                    
                    //UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString( "OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                        let imgPath:String = resp.valueForKey("imgPath") as! String
                        self.UpdateDoctorProfileImage(imgPath)
                    })
                    alertControlle.addAction(action)
                    self.presentViewController(alertControlle, animated: true, completion: nil)
                }else{
                    let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't upload image right now", comment: ""))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }else if reqId == 2{
            
            if (resp.valueForKey("errorMsgEn") == nil){
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't update profile right now", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
                return
                //alert
            }
            
            let responseMessage:String = resp.valueForKey("errorMsgEn") as! String
            
            if responseMessage != "Done" {
                
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't update profile right now", comment: ""))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Updated", comment: ""), msg: NSLocalizedString("Profile is updated", comment: ""))
            
            
            NSUserDefaults.standardUserDefaults().setObject(updatedDoctor!.toDictionary(), forKey: Const.UserDefaultsKeys.drProfile)
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    
    func UpdateDoctorProfileImage(imgPath:String) {
        
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        currentDoctor.imageUrl = imgPath
        
        let url:String = Const.URLs.Doctor + "/" + "\(currentDoctor.drId)"
        
        updatedDoctor = currentDoctor;
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
            
            
            networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: currentDoctor.toDictionary(), reqId: 2, caller: self)
        }
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
