//
//  SceneDelegate.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/11/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
		// Use a UIHostingController as window root view controller
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: JourneysList(journeys: [
                JourneyX(title: "Luna", since: Date().addingTimeInterval(-687000) ,days: 39, button: "💩", accidents: [
                    AccidentX(date: Date().addingTimeInterval(-3600)),
                    AccidentX(date: Date().addingTimeInterval(-7200)),
                    AccidentX(date: Date().addingTimeInterval(-10800))
                ]),
                JourneyX(title: "Diva", since: Date().addingTimeInterval(-87000), days: 32, button: "🐱", accidents: [
                ])
            ]).environment(\.managedObjectContext, context))
            self.window = window
            window.makeKeyAndVisible()
        }
        
        

        for journey in try! context.fetch(Journey.fetchRequest()) {
            context.delete(journey as! Journey)
        }
        
        for accident in try! context.fetch(Accident.fetchRequest()) {
            context.delete(accident as! Accident)
        }
        
        let newJourney = NSEntityDescription.insertNewObject(forEntityName: "Journey", into: context) as! Journey
        newJourney.id = UUID()
        newJourney.since = Date()
        newJourney.title = "Luna"
        newJourney.action = "💩"

        let newAccident = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident.id = UUID()
        newAccident.happenedAt = Date()
        let newAccident1 = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident1.id = UUID()
        newAccident1.happenedAt = Date().addingTimeInterval(-172800)
        let newAccident2 = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident2.id = UUID()
        newAccident2.happenedAt = Date().addingTimeInterval(-172800 * 2)
        
        newJourney.addAccidents([newAccident, newAccident1, newAccident2])
        
        let newJourney1 = NSEntityDescription.insertNewObject(forEntityName: "Journey", into: context) as! Journey
        newJourney1.id = UUID()
        newJourney1.since = Date()
        newJourney1.title = "Diva"

        let newAccident10 = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident10.id = UUID()
        newAccident10.happenedAt = Date().addingTimeInterval(-172800 * 3)
        let newAccident11 = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident11.id = UUID()
        newAccident11.happenedAt = Date().addingTimeInterval(-172800 * 4)
        let newAccident12 = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: context) as! Accident
        newAccident12.id = UUID()
        newAccident12.happenedAt = Date().addingTimeInterval(-172800 * 5)
        
        newJourney.addAccidents([newAccident10, newAccident11, newAccident12])
        
        try! context.save()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
	}


}

