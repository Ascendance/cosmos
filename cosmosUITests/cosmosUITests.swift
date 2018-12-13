//
//  cosmosUITests.swift
//  cosmosUITests
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import XCTest

class cosmosUITests: XCTestCase {
    
    var viewController: UIViewController!

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        NSLog("Test launched with server: " + CONFIG.server)
    }

    override func tearDown() {
        XCUIApplication().terminate()
    }
    
    func testBackAndForeground(){
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(2)
        XCUIDevice.shared.siriService.activate(voiceRecognitionText: "Open cosmos")
    }
    
    func searchInput(text: String, app: XCUIApplication, searchField: XCUIElement){
        
        searchField.tap()
        assert(text.count > 0, "Invalid input given!")
        let firstChar = text.prefix(1)
        let keyChar = app.keyboards.keys[String(firstChar.uppercased())]
        keyChar.tap()
        
        for char in text.suffix(text.count - 1){
            let keyChar = app.keyboards.keys[String(char)]
            keyChar.tap()
        }
        app.keyboards.buttons["Search"].tap()
    }
    
    func clearInput(app: XCUIApplication, searchField: XCUIElement){
        searchField.tap()
        let deleteKey = app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        for _ in stride(from: 0, to: 10, by: 1){
            deleteKey.tap()
        }
    }
    
    func swipeDownGesture(app: XCUIApplication){
        // check if tableview is populated
        if(app.tables.children(matching: .cell).element(boundBy: 0).exists){
            app.tables.children(matching: .cell).element(boundBy: 0).swipeDown()
            
            // fresh empty tableview
        } else {
            app.tables["Empty list"].swipeDown()
        }
    }
    
    func testValidSubreddit(){
        
        let app = XCUIApplication()
        
        // wait for UI to load
        sleep(3)
        
        // tap large title search bar & search
        swipeDownGesture(app: app)
        let searchField = app.searchFields["Search"]
        searchInput(text: "puppy", app: app, searchField: searchField)
        
        // MARK: - Test case 1 > cell with thumbnail
        // ---------------------------------------------------------------------------------------------------------------------
        
        sleep(3) // wait for server
        
        // check if ExploreView cell exist
        var cellExists = app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.exists
        assert(cellExists, "Expected cell does not exist!")
        
        // check if ExploreView cell content is correct
        var cellContents = app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.value
        var cellContentsString = (cellContents != nil) ? cellContents! as! String : ""
        assert(cellContentsString == "Milo’s wearing his Christmas sweater", "Cell contents do not match!")
        
        // launch DetailView Segue
        app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.tap()
        
        // check if DetailView title is correct
        assert(app.navigationBars["Milo’s wearing his Christmas sweater"].exists, "Incorrect navigation bar title!")
        
        var textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
  
        // check correctness of DetailView selftext
        assert(textView.exists, "Detail textview does not exist!")
        assert(textView.value as! String == STRINGS.emptyBody, "Thumbnail post should not have a selftext body!")
        
        // go back - begin #2 & challenges CoreData FRC correctness
        var navigationBar = app.navigationBars["Milo’s wearing his Christmas sweater"]
        navigationBar.buttons["Go Back"].tap()
        
        // MARK: - Test case 2 > cell with no thumbnail
        // ---------------------------------------------------------------------------------------------------------------------
        
        // tap large title search bar & search
        swipeDownGesture(app: app)
        clearInput(app: app, searchField: searchField)
        searchInput(text: "swift", app: app, searchField: searchField)
        
        sleep(3) // wait for server
        
        // check if ExploreView cell exist
        cellExists = app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.exists
        assert(cellExists, "Expected cell does not exist!")
        
        // check if ExploreView cell content is correct
        cellContents = app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.value
        cellContentsString = (cellContents != nil) ? cellContents! as! String : ""
        
        print(cellContentsString)
        assert(cellContentsString == "What’s everyone working on this month? (December 2018)", "Cell contents do not match!")
        
        // launch DetailView Segue
        app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element.tap()
        
        // check if DetailView title is correct
        assert(app.navigationBars["What’s everyone working on this month? (December 2018)"].exists, "Incorrect navigation bar title!")
        
        textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        // check correctness of DetailView selftext
        assert(textView.exists, "Detail textview does not exist!")
        assert(textView.value as! String == "What Swift-related projects are you currently working on?", "Mismatching selftext!")
        
        // go back - begin #3 & challenges CoreData FRC correctness
        navigationBar = app.navigationBars["What’s everyone working on this month? (December 2018)"]
        navigationBar.buttons["Go Back"].tap()
        
        // MARK: - Test case 3 > cell with title but no selftext
        // ---------------------------------------------------------------------------------------------------------------------
        
        sleep(1) // wait for animation
        
        // check if ExploreView cell exist
        cellExists = app.tables.children(matching: .cell).element(boundBy: 20).children(matching: .textView).element.exists
        assert(cellExists, "Expected cell does not exist!")
        
        // check if ExploreView cell content is correct
        cellContents = app.tables.children(matching: .cell).element(boundBy: 20).children(matching: .textView).element.value
        cellContentsString = (cellContents != nil) ? cellContents! as! String : ""
        assert(cellContentsString == "Can I update my version of swift in Xcode 8.2.1 to swift version 4?")
        
        // launch DetailView Segue
        app.tables.children(matching: .cell).element(boundBy: 20).children(matching: .textView).element.tap()
        
        // check if DetailView title is correct
        assert(app.navigationBars["Can I update my version of swift in Xcode 8.2.1 to swift version 4?"].exists, "Incorrect navigation bar title!")
        
        textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        // check correctness of DetailView selftext
        assert(textView.exists, "Detail textview does not exist!")
        assert(textView.value as! String == STRINGS.emptyBody, "empty post should not have a selftext body!")
    }
    
    func testInvalidSubreddit(){
        
        let app = XCUIApplication()
        
        // wait for UI to load
        sleep(3)
        
        // tap large title search bar & search 'xzxxz'
        swipeDownGesture(app: app)
        let searchSearchField = app.searchFields["Search"]
        searchInput(text: "xzxxz", app: app, searchField: searchSearchField)
        
        sleep(3) // wait for server
        
        // excpect error alert
        let errorAlertExists = app.alerts["Subreddit Error"].exists
        assert(errorAlertExists, "Error alert doesn't exist!")
    }
}
