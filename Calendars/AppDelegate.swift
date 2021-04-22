//
//  AppDelegate.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import Cocoa

@main
class AppDelegate: SwiftyObject, NSApplicationDelegate {
  private var windowController: NSWindowController?

  override class func swiftyInitialize() {
    AppContext.initializeApplication()
  }

  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
}
