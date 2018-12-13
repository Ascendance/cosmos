//
//  PostManager.swift
//  cosmos
//
//  Created by William Yang on 12/11/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import CoreData

/**
 Manages insertion, deletion, and counting of the Post entity.
 */
class PostManager {

    //MARK: - Singleton
    static let sharedInstance = PostManager()
    
    private let entityName: String = "Posts"
    private let cdm = CoreDataManager.sharedInstance
    private let moc = CoreDataManager.sharedInstance.baseManagedObjectContext
    
    /**
     attempt delete all Posts within base MOC
     */
    func delete(){
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try moc.execute(deleteRequest)
            moc.reset()
        } catch let error as NSError {
            NSLog("Could not delete! E: \(error.userInfo)")
        }
    }
    
    /**
     attempt save all Posts within base MOC
     */
    func save(){
        do {
            try moc.save()
            //cdm.saveBaseContext()
            NSLog("Datastore save complete!")
        } catch let error as NSError{
            NSLog("Could not save! E: \(error.userInfo)")
        }
    }
    
    /**
     inserts a new Post WITHOUT saving (for efficiency reasons). Save __MUST__ be called afterwards.
     */
    func insert(
        title: String,
        body: String,
        kind: Int,
        thumbHeight: Int,
        thumbWidth: Int,
        thumbURL: String
        
        ){
        
        let post = Posts(context: moc)
        post.title = title
        post.body = body
        post.kind = Int16(kind)
        post.thumbHeight = Int16(thumbHeight)
        post.thumbWidth = Int16(thumbWidth)
        post.thumbURL = thumbURL
        post.created = Date()
    }
    
    /**
     non FRC version of count that counts number of stored Posts
     */
    func count() -> Int{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var count = 0
        do {
            try count = moc.count(for: fetchRequest)
        } catch let error as NSError {
            NSLog("Could not count fetch count! E: \(error), \(error.userInfo)")
        }
        return count
    }
}
