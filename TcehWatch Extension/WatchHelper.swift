//
//  WatchHelper.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 12/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import WatchKit
import WatchConnectivity

class WatchHelper: NSObject {

    static let instance = WatchHelper()

    static let cache = NSUserDefaults.standardUserDefaults()

    // need to add 'dynamic' to work with NSNotification and Key-Value Observing
    dynamic var entries = [[String: AnyObject]]()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
        }
    }

    func transferData(data: AnyObject) {
        print("sending amount \(data) to phone")
        WCSession.defaultSession().transferUserInfo(["data": data])
    }

}


extension WatchHelper: WCSessionDelegate {

    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {

    }

    func sessionDidBecomeInactive(session: WCSession) {

    }

    func sessionDidDeactivate(session: WCSession) {
        session.activateSession()
    }

    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {

        guard let entries = applicationContext["my_entries"] as? [[String: AnyObject]] else { return }

        self.entries = entries

        WatchHelper.cache.setObject(entries, forKey: "cachedEntries")

        // can be done with notification
        // NSNotificationCenter.defaultCenter().postNotificationName("entriesUpated", object: self.entries)
    }

}