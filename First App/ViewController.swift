//
//  ViewController.swift
//  First App
//
//  Created by Hans Tang on 20/09/22.
//

import UIKit
import CleverTapSDK


class ViewController: UIViewController, CleverTapInboxViewControllerDelegate, CleverTapURLDelegate {
    
    @IBOutlet weak var lblCTID: UILabel!
    
    @IBOutlet weak var UserIdentity: UITextField!
    @IBOutlet weak var UserEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard when click anywhere
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        lblCTID.text = CleverTap.sharedInstance()?.profileGetID()
        // Do any additional setup after loading the view
        CleverTap.sharedInstance()?.recordEvent("Main Activity Open")
        
        //inbox init
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
         }))
        
        // Set the URL Delegate
        CleverTap.sharedInstance()?.setUrlDelegate(self)

    }

    @IBAction func btnInbox(_ sender: Any) {
        //CleverTap.sharedInstance()?.recordEvent("Request Inbox Event")
        // config the style of App Inbox Controller
            let style = CleverTapInboxStyleConfig.init()
            style.title = "App Inbox Title"
            //style.navigationTintColor = .blue
        
            //style.backgroundColor = .white
            //style.messageTags = ["TestingFilterTag", "Promotions"]
            //style.navigationBarTintColor = .red
            //style.navigationTintColor = .black
            //style.tabUnSelectedTextColor = .green
            //style.tabSelectedTextColor = .black
            //style.tabSelectedBgColor = .blue
            //style.firstTabTitle = "Promotion"
            
            if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                let navigationController = UINavigationController.init(rootViewController: inboxController)
                self.present(navigationController, animated: true, completion: nil)
          }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        var dob = DateComponents()
        dob.day = 12
        dob.month = 09
        dob.year = 1992
        let d = Calendar.current.date(from: dob)
        let email_gen = UserIdentity.text! + "@email.com"
        let profile: Dictionary<String, AnyObject> = [
            //Update pre-defined profile properties
            "Identity": UserIdentity.text as AnyObject,
            "Email": email_gen as AnyObject,
            //"Email": UserEmail.text as AnyObject,
            //Update custom profile properties
            //"Plan type": "Silver" as AnyObject,
            "Favorite Food": "Pizza" as AnyObject,
            "MSG-push": true as AnyObject,
            "DOB": d as AnyObject,
        ]
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        CleverTap.sharedInstance()?.recordEvent("Login")
        
        self.showToast(message: "Login Clicked", font: .systemFont(ofSize: 12.0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //call any function
            self.lblCTID.text = CleverTap.sharedInstance()?.profileGetID()
            self.showToast(message: "Change CT ID", font: .systemFont(ofSize: 12.0))
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        /*
        //UserDefaults.standard.removeObject(forKey: "WizRocket_")
        //NSLog(UserDefaults.standard.dictionaryRepresentation().keys)
        //NSLog(Array(UserDefaults.standard.dictionaryRepresentation()))
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            //NSLog("\(key) = \(value) \n")
            if key.contains("WizRocket"){
                UserDefaults.standard.removeObject(forKey: key)
                NSLog(key)
            }
        }
        CleverTap.sharedInstance()?.recordEvent("Fresh")
        NSLog("CT ID after clear \(CleverTap.sharedInstance()?.profileGetID()) ")
        self.viewDidLoad()
        self.viewWillAppear(true)
         */
        /*
        // Required field.
        let localInAppBuilder = CTLocalInApp(inAppType: .ALERT,
                                             titleText: "Get Notified",
                                             messageText: "Enable Notification permission",
                                             followDeviceOrientation: true,
                                             positiveBtnText: "Allow",
                                             negativeBtnText: "Cancel")

        // Optional fields.
        localInAppBuilder.setFallbackToSettings(true)

        // Prompt Push Primer with above settings.
        CleverTap.sharedInstance()?.promptPushPrimer(localInAppBuilder.getSettings())
        */
        var dob = DateComponents()
        dob.day = 13
        dob.month = 08
        dob.year = 1990
        let d = Calendar.current.date(from: dob)
        
        if let dhd = ViewController.getDateFromString("1991-08-13", "yyyy-MM-dd") {
            NSLog("DOB DATE: \(dhd)")
            let profile: Dictionary<String, AnyObject> = [
                //Update pre-defined profile properties
                "MSG-push": true as AnyObject,
                "DOB": "$D_636229800000" as AnyObject,
                "Customer type":"Gold" as AnyObject,
                "Grab":"Yes" as AnyObject,
            ]
            
            CleverTap.sharedInstance()?.profilePush(profile)
        }
        

        
        
        
        CleverTap.sharedInstance()?.recordEvent("Logout")
    }
    
    

    @IBAction func btnNPS(_ sender: Any) {
        CleverTap.sharedInstance()?.recordEvent("NPS")
        self.showToast(message: "NPS Clicked", font: .systemFont(ofSize: 12.0))
        
    }
    
    public static func getDateFromString(_ date: String, _ format: String = "hh:mm a") -> Date?{
        var dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier:.gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:date)
    }
    
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    // CleverTapURLDelegate method
    public func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        //print("Handling URL By CT: \(url!) for channel: \(channel)")
        NSLog("Handling URL By CT: \(url!) for channel: \(channel)")
        //CleverTap.sharedInstance()?.recordEvent("open url")
        
        if let url {
            UIApplication.shared.open(url)
            CleverTap.sharedInstance()?.dismissAppInbox()
            
            return false
            
        }
        else{
            return true
        }
        
    }
    
    func messageButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]?) {
        NSLog("App Inbox Button Tapped with custom extras: ", customExtras ?? "");
        //CleverTap.sharedInstance()?.dismissAppInbox();
        }

}

