//
//  AppDelegate.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/11/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "lHVdHK1shndAPmRHVR959RgikwwsGq0Ys1KzGqvK"
            $0.clientKey = "xLhokmVix1amkFxoQq6mssMciVld2W7qO33oehxM"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        //saveInstallationObject()
        return true
    }
    
    func saveInstallationObject()
    {
        if let installation = PFInstallation.current()
        {
            installation.saveInBackground(block: {
                  (succsess: Bool, error: Error?) in
                if(succsess)
                {
                    print("You have been connected!")
                }
                else
                {
                    if let myError = error {
                        print(myError.localizedDescription)
                    }
                    else
                    {
                        print("Unknown error.")
                    }
                }
            })
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

