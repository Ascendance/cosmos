//
//  ExploreTableViewCells.swift
//  cosmos
//
//  Created by William Yang on 12/12/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit

protocol ThumbnailCellDelegate{
    func thumbnailCellTapped(at index: IndexPath)
}

protocol NoThumbnailCellDelegate{
    func noThumbnailCellTapped(at index: IndexPath)
}

class ThumbnailCell: UITableViewCell {
    
    // MARK: - IB outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nscThumbnailHeight: NSLayoutConstraint!
    @IBOutlet weak var nscThumbnailWidth: NSLayoutConstraint!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    // MARK: - properties
    var delegate:ThumbnailCellDelegate!
    var indexPath:IndexPath!
    
    // MARK: - protocol delegates
    @objc func baseViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.delegate?.thumbnailCellTapped(at: indexPath)
    }
    
    @objc func titleTextViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.delegate?.thumbnailCellTapped(at: indexPath)
    }
    
    // see apple documentation
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Gesture when baseView is tapped
        let tapGestureRecognizerBaseView = UITapGestureRecognizer(target: self, action: #selector(baseViewTapped(tapGestureRecognizer:)))
        baseView.isUserInteractionEnabled = true
        baseView.addGestureRecognizer(tapGestureRecognizerBaseView)
        
        // Gesture when titleTextView is tapped
        let tapGestureRecognizerTitleTextView = UITapGestureRecognizer(target: self, action: #selector(titleTextViewTapped(tapGestureRecognizer:)))
        titleTextView.isUserInteractionEnabled = true
        titleTextView.addGestureRecognizer(tapGestureRecognizerTitleTextView)
    }
}

class NoThumbnailCell: UITableViewCell {
    
    // MARK: - IB outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    
    // MARK: - properties
    var delegate:NoThumbnailCellDelegate!
    var indexPath:IndexPath!
    
    // MARK: - protocol delegates
    @objc func baseViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.delegate?.noThumbnailCellTapped(at: indexPath)
    }
    
    @objc func titleTextViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.delegate?.noThumbnailCellTapped(at: indexPath)
    }
    
    // see apple documentation
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Gesture when baseView is tapped
        let tapGestureRecognizerBaseView = UITapGestureRecognizer(target: self, action: #selector(baseViewTapped(tapGestureRecognizer:)))
        baseView.isUserInteractionEnabled = true
        baseView.addGestureRecognizer(tapGestureRecognizerBaseView)
        
        // Gesture when titleTextView is tapped
        let tapGestureRecognizerTitleTextView = UITapGestureRecognizer(target: self, action: #selector(titleTextViewTapped(tapGestureRecognizer:)))
        titleTextView.isUserInteractionEnabled = true
        titleTextView.addGestureRecognizer(tapGestureRecognizerTitleTextView)
    }
}



