//
//  AppDelegate.swift
//  ConcatStateMachine
//
//  Created by Daniel Farrell on 27/02/2016.
//  Copyright © 2016 ExcitonLabs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var concatViewController: ConcatViewController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        window.contentViewController = concatViewController
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

