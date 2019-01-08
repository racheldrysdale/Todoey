//
//  AppDelegate.swift
//  Todoey
//
//  Created by Rachel Drysdale on 27/12/2018.
//  Copyright © 2018 Rachel Drysdale. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//		print(Realm.Configuration.defaultConfiguration.fileURL)

		do {
			_ = try Realm()
		} catch {
			print("Error installing new realm, \(error)")
		}
		
		return true
	}

}

