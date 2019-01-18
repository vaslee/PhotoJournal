//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by TingxinLi on 1/14/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import Foundation
final class PhotoJournalModel {
    private static let filename = "PhotoJournalsList.plist"
    private static var photo = [PhotoJournal]()
    
    
    static func savePhotoJournal() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photo)
           
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    
    static func getPhotoJournal() -> [PhotoJournal] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
       
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photo = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("property list decoding error: \(error)")
                }
            }else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        return photo
    }
    
    static func editItem(item: PhotoJournal, atIndex: Int) {
        photo.remove(at: atIndex)
        photo.insert(item, at: atIndex)
        photo = photo.sorted{ $0.date > $1.date }
        savePhotoJournal()

    }

    static func updateItem(item: PhotoJournal,atIndex: Int) {
//        photo.remove(at: atIndex)
//        photo.insert(item, at: atIndex)
        photo[atIndex] = item
        savePhotoJournal()
        
    }
    static func addPhoto(item: PhotoJournal) {
        photo.append(item)
        savePhotoJournal()
    }
    
    static func delete(atIndex index: Int) {
        photo.remove(at: index)
        savePhotoJournal()
    }
    
}
