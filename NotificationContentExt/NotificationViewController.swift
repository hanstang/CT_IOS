//
//  NotificationViewController.swift
//  NotificationContentExt
//
//  Created by Hans Tang on 27/07/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CTNotificationContent
import CleverTapSDK

class NotificationViewController: CTNotificationViewController {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
}
