import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
     GMSServices.provideAPIKey("AIzaSyCE_eXLb8kfErsUVchK6YSZcgn2JjAltjk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  // SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
  // return true
  // }

  // func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  //   return SDKApplicationDelegate.shared.application(app, open: url, options: options)
  // }
}




//  Swift
//  AppDelegate.swift
//  Replace the code in AppDelegate.swift with the following code.
//
//  Copyright © 2020 Facebook. All rights reserved.
//


    