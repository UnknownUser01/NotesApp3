//
//  AppDelegate.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 04/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
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
    
    private func preloadData() {
//        var context: NSManagedObjectContext!
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: preloadedDataKey) == false {
            guard let url = Bundle.main.url(forResource: "QuizQuestions", withExtension: "plist") else {
                return
            }
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            backgroundContext.perform {
                if let contentArray = NSArray(contentsOf: url) as? [String] {
                    var i = 0
                    do {
                        for item in contentArray {
                            print(item)
                            let questionsObject = Questions(context: backgroundContext)
                            var remainder: Int
                            if i == 0 {
                                remainder = 0
                            } else {
                                remainder = i % 7
                            }
                            self.addToDb(value: remainder, data: item, questionObj: questionsObject)
                            i += 1
                        }
                        
//                        while i <= 209 {
//                            let entity = NSEntityDescription.insertNewObject(forEntityName: Strings.entityQuestions, into: context)
//                            entity.setValue(contentArray[i], forKey: Strings.attributeSiNum)
//
//                            do {
//                                try context.save()
//                                print(Strings.createDataSucess)
//                            } catch {
//                                print(error.localizedDescription)
//                            }
//                        }
                        
                        try backgroundContext.save()
                        userDefaults.set(true, forKey: preloadedDataKey)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addToDb(value: Int, data: String, questionObj: Questions) {
        switch value {
        case 0:
            questionObj.siNum = data
        case 1:
            questionObj.question = data
        case 2:
            questionObj.option1 = data
        case 3:
            questionObj.option2 = data
        case 4:
            questionObj.option3 = data
        case 5:
            questionObj.option4 = data
        case 6:
            questionObj.correctOption = data
        default:
            print("Invalid Data")
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NotesDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
