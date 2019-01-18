//
//  PhotoDetailViewController.swift
//  PhotoJournal
//
//  Created by TingxinLi on 1/14/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    private var PhotoPickerViewController: UIImagePickerController!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var descriptions: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var photojournal: PhotoJournal?
    var indexNum = 0
    
    private var titlePlaceholder = "Enter Title"
    var photos: PhotoJournal!
  //  var photoSelected = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerViewController()
        descriptions.delegate = self
 
    }
   
    
    private func setupImagePickerViewController() {
        PhotoPickerViewController = UIImagePickerController()
        PhotoPickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        if let photojournalt = photojournal {
            imageView.image = UIImage(data: photojournalt.imageData)
            
        }
        if let photoJournal = photojournal {
            descriptions.text = photoJournal.description
        }
    }
    
    private func showPhotoJournalController() {
        
        present(PhotoPickerViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        guard let text = descriptions.text else { return } // check if there is description
        guard let imageData = imageView.image else {return} // check if there is image exsit
        
        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withFullTime, .withInternetDateTime, .withTimeZone,.withDashSeparatorInDate]
        
        let timestamp = isoDateFormatter.string(from: date)
        let photo = PhotoJournal.init(createdAt: timestamp, imageData: imageData.jpegData(compressionQuality: 0.5)!, description: text)
        
        
        if let photoJournal = photojournal {
            PhotoJournalModel.updateItem(item: photo,atIndex: indexNum)
        } else {
            PhotoJournalModel.addPhoto(item: photo)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        PhotoPickerViewController.sourceType = .photoLibrary
        showPhotoJournalController()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        PhotoPickerViewController.sourceType = .camera
        showPhotoJournalController()
    }
    
}

extension PhotoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
           // photoSelected = image
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptions.text == titlePlaceholder {
            descriptions.text = ""
            descriptions.textColor = .black
        }
    }
}
