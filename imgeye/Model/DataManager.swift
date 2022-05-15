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
    
    func saveFavorivePhoto(withID id: String) {
        guard let managedContext = context else {
            print("Failed to get CoreData context.")
            return
        }
        
        let a = FavoritePhotoDataModel(context: managedContext)
        a.id = id
        
        commitChanges()
    }
    
}
