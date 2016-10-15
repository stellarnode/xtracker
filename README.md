# xTracker iOS Mobile App

This is a project developed as part of the #tceh 'iOS Development in Swift' course.

With xTracker you can:

* Add new entries with amount, currency, date, venue (depending on location) and category
* Change current base currency (existing entries are recalculated using historic FX rates)
* Existing entries are displayed in both original and base currency for reference
* Edit existing entries by updating date, currency and amount of the entry
* See entries on a map with pins where the relevant expense was tracked
* See statistics of expenses on line and pie chart graphs

The xTracker app also has necessary elements to work as a Today Widget and as an Apple Watch app. You can add new expense entries from both the Widget and the Watch app.

## Installation and Editing

Please remember to install correct cocoapod files by running ```pod install``` in your terminal.

To edit the Xcode project, remember to open ```TcehProject.xcworkspace``` (and not the default .xcodeproj file) for the cocoapods to be available and linked correctly.

Also, for the app to work, you will need a ```Env.swift``` file with all necessary API keys and constants.
