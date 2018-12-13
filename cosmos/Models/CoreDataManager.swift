import Foundation
import CoreData

/**
 Manages the entire CoreData stack.
 
 The simplest form of CoreData stack is made of 3 parts.
 This app uses CoreData backed by SQLite.
 
 - #1 MOM - Managed Object Model > Model(s) that describes data stored
 - #2 PSC - Persistent Store Coordinator > Collection(s) of stores
 - #3 MOC - Managed Object Context > Collection(s) of managed Objects
 
 */
class CoreDataManager {
    
    // MARK: - Singleton
    static let sharedInstance = CoreDataManager()
    
    /**
     fetches documents path for SQLite store save location
     */
    private lazy var applicationDocumentsDirectory: URL = {
        // This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    /**
     completely resets CoreData and all associated SQLite stores
     - Parameter storeType: defaults to NSSQliteStoreType (String)
     */
    func destroyCoreData(storeType : String = NSSQLiteStoreType) throws {
        guard let storeB1URL = basePersistentStoreCoordinator.persistentStores.last?.url else {
            NSLog("Missing Base Config Store URL")
            return
        }
        try basePersistentStoreCoordinator.destroyPersistentStore(at: storeB1URL, ofType: storeType)
        try basePersistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: "Base", at: storeB1URL)
    }
    
    /**
     #1 MOM > cosmos.xcdatamodeld -> cosmos.momd
     */
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // momd = xcdatamodeld compiled
        let modelURL = Bundle.main.url(forResource: "cosmos", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /**
     #2 PSC > sqlite management
     */
    lazy var basePersistentStoreCoordinator: NSPersistentStoreCoordinator = {
       
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("System.sqlite")
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "Base", at: url, options: options)
        } catch let error as NSError{
            NSLog("Error while initializing PersistentStoreCoordinator! E: \(error.userInfo)")
            //abort()
        }
        return coordinator
    }()

    /**
     #3 MOC > managed object context
     */
    lazy var baseManagedObjectContext: NSManagedObjectContext = {
        var baseManagedObjectContext: NSManagedObjectContext?
        let basecoordinator = self.basePersistentStoreCoordinator
        baseManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        baseManagedObjectContext?.persistentStoreCoordinator = basePersistentStoreCoordinator
        return baseManagedObjectContext!
    }()
    
    /**
     #3 MOC > saves base context
     */
    func saveBaseContext () throws{
        //throw RuntimeError.runtimeError("CoreData Save Error")
        
        do {
            try baseManagedObjectContext.save()
        } catch let error as NSError{
            NSLog("Error while saving Base Context! E: \(error), \(error.userInfo)")
            throw RuntimeError.runtimeError("CoreData Save Error")
        }
    }
}

