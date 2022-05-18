//
//  DataManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    public static let shared = DataManager()
    
    private init() {}
    
    var context: NSManagedObjectContext? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return nil
        }

        return context
    }
    
    private func commitChanges() {
        do {
            try context?.save()
        } catch {
            print("Error saving favorite photo: \(error)")
        }
    }
    
    func readFavoritePhotos() -> [FavoritePhotoDataModel]? {
        guard let context = context else {
            print("Failed to get CoreData context.")
            return nil
        }

        let request: NSFetchRequest<FavoritePhotoDataModel> = FavoritePhotoDataModel.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to read FavoritePhotoDataModel: \(error)")
            return nil
        }
    }
    
    private func readFavoritePhoto(withID id: String) -> FavoritePhotoDataModel? {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return nil
        }
        
        let request = FavoritePhotoDataModel.fetchRequest()
        let favoritePhotoPredicate = NSPredicate(format: "id MATCHES %@", id)
        request.predicate = favoritePhotoPredicate
        
        do {
            let fpdm = try managedContext.fetch(request)
            return !fpdm.isEmpty ? fpdm[0] : nil
        } catch {
            print("Error fetching data from context \(error)")
            return nil
        }
    }
    
    func isPhotoFavorite(basedOnID id: String) -> Bool {
        if let _ = readFavoritePhoto(withID: id) {
            return true
        } else {
            return false
        }
    }
    
    func saveFavorivePhoto(withID id: String) {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return
        }
        
        let a = FavoritePhotoDataModel(context: managedContext)
        a.id = id
        
        commitChanges()
    }
    
    func deleteFromFavoritesPhoto(withID id: String) {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return
        }
        
        guard let favoritePhotoToDelete = readFavoritePhoto(withID: id) else {
            print("Can not find favorite photo with id =\(id).")
            return
        }
        
        managedContext.delete(favoritePhotoToDelete)
        commitChanges()
    }
    
    func save(photoWithID id: String, andUIImage image: UIImage) {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return
        }
        
        let imageJPEGData = image.jpegData(compressionQuality: 1.0)
        let photo = PhotoDataModel(context: managedContext)
        photo.id = id
        photo.storedImage = imageJPEGData
        
        commitChanges()
    }
    
    func read(photoWithID id: String) -> UIImage? {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return nil
        }
        
        let request = PhotoDataModel.fetchRequest()
        let photoDataPredicate = NSPredicate(format: "id MATCHES %@", id)
        request.predicate = photoDataPredicate
        
        do {
            let photos = try managedContext.fetch(request)
            return !photos.isEmpty ? UIImage(data: photos[0].storedImage!) : nil
        } catch {
            print("Error fetching data from context \(error)")
            return nil
        }
    }
    
    func delete(photoWithID id: String) {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return
        }
        
        guard let photoToDelete = readFavoritePhoto(withID: id) else {
            print("Can not find photo with id =\(id).")
            return
        }
        
        managedContext.delete(photoToDelete)
        commitChanges()
    }
    
}
