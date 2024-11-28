//
//  DataBaseLayer.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 27/11/24.
//

import UIKit
import CoreData

class DBHelper: NSObject {
    
    //MARK: - Generic Methods
    class func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

    class func saveRecord(coin: [CoinModel]) {
        if DBHelper.clearAllDBData() {
            let context = DBHelper.getContext()
            coin.enumerated().forEach { (index, item) in
                let cryptoCoing = CryptoEntity.newObject() as? CryptoEntity
                cryptoCoing?.isActive = item.isActive
                cryptoCoing?.isNew = item.isNew
                cryptoCoing?.name = item.name
                cryptoCoing?.symbol = item.symbol
                cryptoCoing?.type = item.type
                cryptoCoing?.sequenceId = Int16(index)
            }
            
            do {
                try context.save() // Attempt to save the data
            } catch {
                // Handle error if the save fails
                print("Error saving coin records: \(error.localizedDescription)")
            }
        }
    }
    
    class func getTheSavedRecord() -> [CoinModel]? {
        var data: [CoinModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CryptoEntity")
        do {
            let sortDescriptor = NSSortDescriptor(key: "sequenceId", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let results = try DBHelper.getContext().fetch(fetchRequest)
            
            results.forEach({ record in
                if let cryptData = (record as? CryptoEntity)?.convertToCoinResponseModel() {
                    data.append(cryptData)
                }
            })
            return data
        }  catch let error {
            debugPrint("fetchAll: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func clearAllDBData() -> Bool {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CryptoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let context = DBHelper.getContext()
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch {
            print ("There was an error")
            return false
        }
    }
    
}

extension NSManagedObject {
    
    class func newObject() -> NSManagedObject? {
        
        guard  let entityName = entity().name else {
            return nil
        }
        let context = DBHelper.getContext()
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return managedObject
    }
}

extension CryptoEntity {
    func convertToCoinResponseModel() -> CoinModel {
        return CoinModel(name: self.name, symbol: self.symbol, isNew: self.isNew, isActive: self.isActive, type: self.type)
    }
}
