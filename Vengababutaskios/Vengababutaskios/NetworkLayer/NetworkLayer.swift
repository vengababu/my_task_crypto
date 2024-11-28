//
//  NetworkLayer.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/")!

    func fetchCryptoData(completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: baseURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: noData, code: -1, userInfo: nil)))
                return
            }

            do {
                let cryptos = try JSONDecoder().decode([CoinModel].self, from: data)
                completion(.success(cryptos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
