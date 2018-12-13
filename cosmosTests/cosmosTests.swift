//
//  cosmosTests.swift
//  cosmosTests
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import XCTest
import SwiftyJSON
import CoreData
@testable import cosmos

class cosmosTests: XCTestCase {

    override func setUp() {
        let cdm = CoreDataManager.sharedInstance
        do {
            try cdm.destroyCoreData()
            try cdm.saveBaseContext()
        } catch let error as NSError {
            NSLog("Setup error! E: \(error.userInfo)")
        }
    }

    override func tearDown() {
        let cdm = CoreDataManager.sharedInstance
        do {
            try cdm.destroyCoreData()
            try cdm.saveBaseContext()
        } catch let error as NSError {
            NSLog("teardown error! E: \(error.userInfo)")
        }
    }
    
    /* network tests */
    func testConnection(){
        
        let expectation1 = XCTestExpectation(description: "Network test valid")
        NetworkController.testConnection(destination: CONFIG.testURL, completion: { response in
            assert(response == 1, "Invalid test connection completion response!")
            expectation1.fulfill()
        })
        
        let expectation2 = XCTestExpectation(description: "Network test invalid")
        NetworkController.testConnection(destination: "https://abc.def.ghi.jkl", completion: { response in
            assert(response == -1, "Invalid test connection completion response!")
            expectation2.fulfill()
        })
        
        wait(for: [expectation1, expectation2], timeout: 5.0)
    }
    
    func testFetchSubreddit(){
        
        let expectation1 = XCTestExpectation(description: "subreddit test valid")
        NetworkController.fetchSubreddit(subreddit: "puppy", completion: { response in
            assert(response == 1, "Invalid fetch completion response!")
            expectation1.fulfill()
        })
        
        let expectation2 = XCTestExpectation(description: "subreddit test invalid")
        NetworkController.fetchSubreddit(subreddit: "zzxxxxz", completion: { response in
            assert(response == -1, "Invalid fetch completion response!")
            expectation2.fulfill()
        })
        
        wait(for: [expectation1, expectation2], timeout: 5.0)
    }
    
    func testCoreData(){
        
        let cdm = CoreDataManager.sharedInstance
        let pm = PostManager.sharedInstance
        
        // PostManager
        pm.delete()
        pm.save()
        assert(pm.count() == 0, "CoreData Posts entity should contain 0 entries!")
        pm.insert(title: "test", body: "test", kind: 0, thumbHeight: 0, thumbWidth: 0, thumbURL: "abc")
        pm.insert(title: "test", body: "test", kind: 1, thumbHeight: 100, thumbWidth: 100, thumbURL: "abc")
        pm.save()
        assert(pm.count() == 2, "CoreData Posts should have exactly 2 entries at this point in time!")
        
        do {
            // Delete the store and recreate. Verify that the new store exists
            try cdm.destroyCoreData()
            
            let applicationDocumentsDirectory: URL = {
                // This code uses a directory named in the application's documents Application Support directory.
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return urls[urls.count-1]
            }()
            
            let url = applicationDocumentsDirectory.appendingPathComponent("System.sqlite")
            assert(FileManager.default.fileExists(atPath: url.path), "System.sqlite does not exist!")
            
        } catch let error as NSError {
            NSLog("Could not test CoreData destruction! E: \(error.userInfo)")
        }
    }
    
    func testBackAndForeground(){
        XCUIDevice().press(XCUIDevice.Button.home)
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(launchApp), userInfo: nil, repeats: false)
    }
    
    func launchApp() {
        XCUIApplication().launch()
    }    
}
