//
//  APIServiceProtocol.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation
// Protocol for API Service
protocol APIServiceProtocol {
    func fetchDataFromAPI(completion: @escaping (Result<[CoinModel], Error>) -> Void)
}

// Concrete implementation of APIService
class APIService: APIServiceProtocol {
    func fetchDataFromAPI(completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        NetworkManager.shared.fetchCryptoData { result in
            completion(result)
        }
    }
}
