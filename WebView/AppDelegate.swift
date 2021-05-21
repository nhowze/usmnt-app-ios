//
//  OnlineAppCreator.com
//  WebViewGold for iOS 5.2 (Swift)
//

import UIKit
import UserNotifications
import OneSignal
import GoogleMobileAds

var registerlocalpush = "true"  //set to "true" to ask user for push notication permission in general



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
               
        
        
        Flurry.startSession("KMZH5GT3MJNPMXX6T9ZV")
        
        
        if Constants.kPushEnabled
        {
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
            
            OneSignal.initWithLaunchOptions(launchOptions,appId: "978b8197-0ffa-4401-90be-0c4ab01aced0",handleNotificationAction: {(result) in let payload = result?.notification.payload
                if let additionalData = payload?.additionalData {
                let noti_url = additionalData["url"] as! String
                    UserDefaults.standard.set(noti_url, forKey: "Noti_Url")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenWithNotificationURL"), object: nil, userInfo: nil)

                }},settings: onesignalInitSettings)
            
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        }
      //  GADMobileAds.configure(withApplicationID: "ca-app-pub-8135666329208851~7700228524")
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
 
        
        if registerlocalpush.isEqual("true")
        {
            if application.responds(to: #selector(getter: application.isRegisteredForRemoteNotifications))
            {
                if #available(iOS 10.0, *)
                {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {(accepted, error) in
                        if !accepted {
                            print("Notification access denied.")
                        }
                    }
                }
                else
                {
                    application.registerUserNotificationSettings(UIUserNotificationSettings(types: ([.sound, .alert, .badge]), categories: nil))
                    application.registerForRemoteNotifications()
                }
            }
            else
            {
                application.registerForRemoteNotifications(matching: ([.badge, .alert, .sound]))
            }
        }
        
        return true
    }
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let _ = components.path,
            let params = components.queryItems else {
                print("Invalid URL or missing")
                return false
        }
        
        if let url  = params.first(where: { $0.name == "link" })?.value {
            UserDefaults.standard.set(url, forKey: "DeepLinkUrl")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenWithExternalLink"), object: nil, userInfo: nil)

            return true
        } else {
            print("url missing")
            return false
        }
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}
