//
//  ViewController.swift
//  PhotoJournal
//
//  Created by TingxinLi on 1/14/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import UIKit
import AVFoundation
class PhotoJournalViewController: UIViewController {
    
    var photoJournalArray = PhotoJournalModel.getPhotoJournal() {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        photoJournalArray = PhotoJournalModel.getPhotoJournal()
    }
    
    @IBAction func detailButtonPressed(_ sender: UIButton) {

            let alert = UIAlertController(title: "What do you need?", message: "Please Select an Option", preferredStyle: .actionSheet)
            let shareButton = UIAlertAction(title: "Share", style: .default, handler: { (action) in
                let shareText = self.photoJournalArray[sender.tag].description
                if let image = UIImage(data: self.photoJournalArray[sender.tag].imageData) {
                    let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
                    self.present(vc, animated: true)
                    
                } })
            
            let editButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                PhotoJournalModel.editItem(item: self.photoJournalArray[sender.tag], atIndex: sender.tag)
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                guard let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailController") as? PhotoDetailViewController else { return }
                viewController.indexNum = sender.tag
                viewController.photojournal = self.photoJournalArray[sender.tag]
                self.present(viewController, animated: true, completion: nil)
                
            })
            
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in PhotoJournalModel.delete(atIndex: sender.tag)
               // self.collectionView.reloadData()
                self.photoJournalArray = PhotoJournalModel.getPhotoJournal()
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in })
            
            alert.addAction(shareButton)
            alert.addAction(editButton)
            alert.addAction(deleteButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
            
        
    }
    
    
    
}

extension PhotoJournalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoJournalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("PhotoCell error")
        }
        
        let photoDetail = photoJournalArray[indexPath.row]
        photoCell.descriptions.text = photoDetail.description
        photoCell.date.text = photoDetail.dateFormattedString
        photoCell.detailButton.tag = indexPath.row
        if let image = UIImage(data: photoDetail.imageData){
        photoCell.imageJournal.image = image
        }
        
        
        return photoCell
    }
    
    
}
