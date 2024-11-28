//
//  DatabaseServiceProtocol.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation
protocol DatabaseServiceProtocol {
    func fetchData() -> [CoinModel]  // For simplicity, let's assume we are fetching strings
    func saveData(_ data: [CoinModel])
}

class DatabaseService: DatabaseServiceProtocol {
    func fetchData() -> [CoinModel] {
        // Simulate fetching data from a local database
            return DBHelper.getTheSavedRecord() ?? []
    }
    
    func saveData(_ data: [CoinModel]) {
        // Simulate saving data to a local database
        DispatchQueue.main.async {
            DBHelper.saveRecord(coin: data)
        }
    }
}
