//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 02/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        testRequest()
        
        return true
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
    
    /*
        ALL TESTS
     */
    
    func testRequest() {
        print("--------------------------------")
        print("\t\tREQUEST TESTS")
        print("--------------------------------")
        let req = Request(_url: "http://192.168.1.99/post")
        req.getPersons() { persons in
            for person in persons {
                print("GET Response -> Name: \(person.name) | Age: \(person.age)")
            }
            
        }
        
        let person = Person(name: "Matt", age: 21)
        req.postPerson(person: person) { response in
            print("POST Response -> \(response)")
        }
    }


}
