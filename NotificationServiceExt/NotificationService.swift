//
//  NotificationService.swift
//  NotificationServiceExt
//
//  Created by Hans Tang on 29/11/22.
//

import UserNotifications
import CleverTapSDK
import CTNotificationService
import AVFoundation

class NotificationService: CTNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        NSLog("this is image")
        
        NSLog("CT ID on Service Extension : \(CleverTap.sharedInstance()?.profileGetID()) ")
        //self.contentHandler = contentHandler
        //bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        //NSLog(request.content.userInfo)
        
        //hans11
        //CleverTap.sharedInstance()?.onUserLogin(profile)
        
        let profile: Dictionary<String, AnyObject> = [
            //Update pre-defined profile properties
            "Identity": "hans11" as AnyObject,
        ]
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        CleverTap.sharedInstance()?.recordEvent("Notif Service")
        
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
        
            contentHandler(bestAttemptContent)
        }
        
        super.didReceive(request, withContentHandler: contentHandler)
        
        //AudioServicesPlaySystemSound(1520)
    }
    
    //override func serviceExtensionTimeWillExpire() {
    //    // Called just before the extension will be terminated by the system.
    //    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    //        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
    //            contentHandler(bestAttemptContent)
    //        }
    //}

}
