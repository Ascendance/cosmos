//
//  NetworkController.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreData

/**
 (N)etworking Component of MVC-N. Manages networking and writes to CoreData.
*/
class NetworkController {
    
    /**
     tests connection to network destination
     - Parameter destination: http network destination (String)
     - Parameter completion: callback after async op is complete (success -> Int)
     - Parameter success: STATUSCODE okay / fail
     */
    static func testConnection(destination: String, completion: @escaping (_ success: Int) -> Void){
        
        if((NetworkReachabilityManager()?.isReachable)!){
            // Alamofire has been renamed AF in v5+
            AF.request(destination, method: .get, encoding: JSONEncoding.default) .responseJSON { response in
                switch response.result {
                    
                case .success(_):
                    // No error
                    completion(STATUSCODE.okay)
                case .failure(_):
                    // Error
                    completion(STATUSCODE.fail)
                }
            }
        } else {
            // Device disconnected from network
            // near impossible to unit test
            completion(STATUSCODE.fail)
        }
    }
    
    /**
     fetches given Subreddit and calls saveSubreddit to save into CoreData.
     
     - Important
     ViewController/TableViewController tableview & FRC __MUST__ be reloaded prior and after fetchSubreddit call
     
     - Parameter subreddit: subreddit JSON object (String)
     - Parameter completion: callback after async op is complete
     - Parameter success: STATUSCODE okay / fail
     */
    static func fetchSubreddit(subreddit: String, completion: @escaping (_ success: Int) -> Void){
        
        if((NetworkReachabilityManager()?.isReachable)!){
            
            let PMInstance = PostManager.sharedInstance
            
            // delete old datastore
            PMInstance.delete()
            
            // load new data into datastore
            let destination = CONFIG.server + subreddit + ".json"
            NSLog("accessing network: \(destination)")
            
            AF.request(destination, method: .get, encoding: JSONEncoding.default) .responseJSON { response in

                switch response.result {                    
                case .success(_):
                    
                    let json = JSON(response.result.value!)
                    saveSubReddit(children: json["data"]["children"])
                    PMInstance.save()
                    
                    // check if sub actually exist
                    if(json["data"]["dist"].int == 0){
                        completion(STATUSCODE.fail)
                    } else {
                        completion(STATUSCODE.okay)
                    }
                    
                case .failure(_):
                    // Error
                    completion(STATUSCODE.fail)
                }
            }
        } else {
            // Device disconnected from network
            // near impossible to unit test
            completion(STATUSCODE.fail)
        }
    }
    
    /**
     helper that parses subreddit JSON children object then save to CoreData
     - Parameter children: subreddit JSON children object (JSON)
     */
    static private func saveSubReddit(children: JSON){
        
        let PMInstance = PostManager.sharedInstance
        for i in stride(from: 0, to: children.count, by: 1){

            // 1
            let title = children[i]["data"]["title"].string
            let selftext = children[i]["data"]["selftext"].string
            let thumbURL =  children[i]["data"]["thumbnail"].string
            
            // Per specifications: "In the case where no thumbnail URL is available"
            // "default" and "self" is not considered valid URL
            let kind = (selftext == "" && thumbURL != "" && thumbURL != "default" && thumbURL != "self") ? 1 : 0            
            let thumbWidth = (kind == 1) ? children[i]["data"]["thumbnail_width"].int! : 0
            let thumbHeight = (kind == 1) ? children[i]["data"]["thumbnail_height"].int! : 0
            
            // edge case: https://reddit.com/r/zzxx
            if((title != nil && thumbURL != nil) || (title != nil && selftext != nil)){
                PMInstance.insert(title: title!, body: selftext!, kind: kind, thumbHeight: thumbHeight, thumbWidth: thumbWidth, thumbURL: thumbURL!)
            }
        }
        NSLog("Saved \(PMInstance.count()) posts to datastore")
    }
}


