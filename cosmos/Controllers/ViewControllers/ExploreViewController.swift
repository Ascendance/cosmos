//
//  ExploreViewController.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

/**
 ExploreViewController with delegates for thumbnail/no thumbnail cells
 */
class ExploreViewController: UIViewController, ThumbnailCellDelegate, NoThumbnailCellDelegate {

    // MARK: IB outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: variables
    private var fetchedResultsController: NSFetchedResultsController<Posts>!
    private var subReddit: String = ""
    private var postTitle: String = ""
    private var selftext: String = ""
    
    // MARK: tableview cell delegates
    
    /**
     delegation for cell with no thumbnail
     - Parameter index: index of cell in table (IndexPath)
     */
    func noThumbnailCellTapped(at index: IndexPath) {
        NSLog("Cell without thumbnail tapped at index \(index.row)")
        let post = fetchedResultsController.object(at: index)
        selftext = (post.body != nil) ? post.body! : ""
        postTitle = post.title!
        
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
    }
    
    /**
     delegation for cell with thumbnail
     - Parameter index: index of cell in table (IndexPath)
     */
    func thumbnailCellTapped(at index: IndexPath) {
        NSLog("Cell with thumbnail tapped at index \(index.row)")
        let post = fetchedResultsController.object(at: index)
        selftext = (post.body != nil) ? post.body! : ""
        postTitle = post.title!
        
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
    }
    
    // MARK: - FRC initialization
    
    /**
     Initializes controller FRC to the Posts entity
     */
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Posts>(entityName: "Posts")
        let sortKey = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sortKey]
        let moc = CoreDataManager.sharedInstance.baseManagedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - VC lifecycle
    
    // see apple documentation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.navigationItem.searchController = search
        
        // initial loading
        self.initializeFetchedResultsController()
        self.fetchedResultsController.managedObjectContext.reset()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

/**
 Extends ExploreViewController to handle title search bar
 */
extension ExploreViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // see apple documentation
    func updateSearchResults(for searchController: UISearchController) {
        subReddit = searchController.searchBar.text!.lowercased()
    }
    
    // see apple documentation
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NSLog("attempting to fetch subreddit: \(subReddit)")

        self.fetchedResultsController = nil
        tableView.delegate = nil
        NetworkController.fetchSubreddit(subreddit: subReddit, completion: {response in
            if(response != STATUSCODE.okay){
                Tools.displayAlert(vc: self, title: STRINGS.subredditFailedTitle, body: STRINGS.subredditFailedBody)
            }
            self.initializeFetchedResultsController()
            self.tableView.delegate = self
            self.tableView.reloadData()
        })
    }
}

/**
 Extends ExploreViewController to handle CoreData FetchedResultsController
 */
extension ExploreViewController: NSFetchedResultsControllerDelegate {
    
    // see apple documentation
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO: implement if app interacts with CoreData on a row-by-row basis
    }
}

/**
 extends ExploreViewController to handle tableViews
 */
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    // see apple documentation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        do {            
            if(fetchedResultsController != nil){
                try self.fetchedResultsController.performFetch()
            }
        } catch let error as NSError {
            print(error.localizedFailureReason!)
        }
        
        if(fetchedResultsController != nil && fetchedResultsController.fetchedObjects != nil){
            count = (fetchedResultsController.fetchedObjects?.count)!
        }
        return count
    }
    
    // see apple documentation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = fetchedResultsController.object(at: indexPath)
        
        // kind 0 > has no thumbnail
        if(post.kind == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoThumbnailCell", for: indexPath) as! NoThumbnailCell
            configureCell(titleTextView: cell.titleTextView, post: post)
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        
        // kind 1 > has thumbnail
        } else if(post.kind == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
            configureCell(titleTextView: cell.titleTextView, post: post)
            configureThumbnail(thumbImageView: cell.thumbnailImageView, thumbWidthNsc: cell.nscThumbnailWidth, thumbHeightNsc: cell.nscThumbnailHeight, post: post)
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! ThumbnailCell
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    /**
     configures a cell's title TextView
     - Parameter titleTextView: title TextView (UITextView)
     - Parameter post: CoreData posts entity at row (Posts)
     */
    func configureCell(titleTextView: UITextView, post: Posts){
        titleTextView.text = post.title!
    }
    
    /**
     configures a cell's thumbnail ImageView
     - Parameter thumbImageView: thumbnail (UIImageView)
     - Parameter thumbWidthNsc: thumbnail IB Width constraint (NSLayoutConstraint)
     - Parameter thumbHeightNsc: thumbnail IB Height constraint (NSLayoutConstraint)
     - Parameter post: CoreData posts entity at row (Posts)
     */
    func configureThumbnail(thumbImageView: UIImageView, thumbWidthNsc: NSLayoutConstraint, thumbHeightNsc: NSLayoutConstraint, post: Posts){
        thumbImageView.kf.setImage(with: URL(string: post.thumbURL!))
        thumbWidthNsc.constant = CGFloat(post.thumbWidth)
        thumbHeightNsc.constant = CGFloat(post.thumbHeight)
    }
    
    // see apple documentation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: DetailViewController.self)){
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.postTitle = postTitle
            destinationVC.selftext = selftext
        }
    }
}
