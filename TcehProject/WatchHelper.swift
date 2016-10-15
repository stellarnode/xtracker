//
//  WatchHelper.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 12/10/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchHelper: NSObject {

    static let instance = WatchHelper()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
        }
    }

    func updateContext() {
        let lastEntries = Entry.loadEntries(5)

        let simpleEntries = lastEntries.map { entry in
            return [
                "amount": entry.amount,
                "category": entry.category
            ]
        }

        print(simpleEntries)

        do {
            try WCSession.defaultSession().updateApplicationContext(["my_entries": simpleEntries])
        } catch let error {
            print("error updating context: \(error)")
        }
    }
}


extension WatchHelper: WCSessionDelegate {

    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {

        guard activationState == .Activated else { return }

        NSOperationQueue.mainQueue().addOperationWithBlock {

            self.updateContext()

        }
    }

    func sessionDidBecomeInactive(session: WCSession) {

    }

    func sessionDidDeactivate(session: WCSession) {
        session.activateSession()
    }

}