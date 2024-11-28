//
//  CryptoListViewModel.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation


class CryptoListViewModel {
    private var dbService: DatabaseServiceProtocol
    private var apiService: APIServiceProtocol
    
    var allCryptos: [CoinModel] = []
    var filteredCryptos: [CoinModel] = []
    
    // Closure to notify the ViewController about data updates
    var updateData: (([CoinModel]) -> Void)?
    
    init(dbService: DatabaseServiceProtocol, apiService: APIServiceProtocol) {
        self.dbService = dbService
        self.apiService = apiService
    }
    
    func fetchCryptoList() {
        let dbData = dbService.fetchData()
        // Notify ViewController with data from DB (even if it's cached)
        if !dbData.isEmpty || !NetworkMonitor.shared.isConnected {
            self.handlingTheResponse(dbData)
        }
        // Step 2: Fetch fresh data from the API in the background
        apiService.fetchDataFromAPI { [weak self] result in
            switch result {
            case .success(let apiData):
                // Step 3: Check if the data from API is the same as the data in the DB
                if dbData != apiData {
                    // If the data is different, save the new data to the DB and notify the ViewController
                    self?.dbService.saveData(apiData)
                    self?.handlingTheResponse(apiData)
                } else {
                   // If the data is the same, don't update
                    print("Data is the same, no update needed")
                }
            case .failure(let error):
                self?.updateData?([])
                // Handle API error if necessary
                print("API Error: \(error.localizedDescription)")
            }
        }
    }
    
    func handlingTheResponse(_ cyptoData: [CoinModel]) {
        self.allCryptos = cyptoData
        self.updateTheCoinImages()
        self.updateData?(cyptoData)
    }
    

    private func updateTheCoinImages() {
        for item in self.allCryptos {
            if item.type?.lowercased() == "coin" && item.isActive == true {
                item.imageName = "activeCoin"
                item.bgColor = .clear
                item.isTagShown = false
            } else if item.type?.lowercased() == "token" && item.isActive == true {
                item.imageName = "activeToken"
                item.bgColor = .clear
                item.isTagShown = false
            } else if item.isActive == false {
                item.imageName = "inActiveCoin"
                item.bgColor = .gray
                item.isTagShown = true
            } else if item.isNew == true {
                item.imageName = "activeToken"
                item.bgColor = .clear
                item.isTagShown = true
            }
        }
        self.filteredCryptos = self.allCryptos
    }
    
    func applyFilter(selectedFilterOptions: [FilterModel]) {
        self.filteredCryptos = []
        if selectedFilterOptions.isEmpty {
            self.filteredCryptos = self.allCryptos
        } else {
            let filteredValue = self.allCryptos
            selectedFilterOptions.forEach { filter in
                var output: [CoinModel] = []
                switch filter.title {
                case activeCoins:
                    output = filteredValue.filter { $0.isActive }
                case inactiveCoins:
                    output = filteredValue.filter { !$0.isActive }
                    
                case onlyTokens:
                    output = filteredValue.filter { $0.type?.lowercased() ?? "" == "token" }
                    
                case onlyCoins:
                    output = filteredValue.filter { $0.type?.lowercased() ?? "" == "coin" }
                    
                case newCoins:
                    output = filteredValue.filter { $0.isNew }
                    
                default:
                    break
                }
                self.filteredCryptos.append(contentsOf: output)
            }
            self.filteredCryptos = self.removeDuplicates(from: self.filteredCryptos)
        }
        self.updateData?(self.filteredCryptos)
    }
    
    func removeDuplicates(from coins: [CoinModel]) -> [CoinModel] {
        var uniqueCoins: [CoinModel] = []
        
        for coin in coins {
            if !uniqueCoins.contains(where: { $0 == coin }) {
                uniqueCoins.append(coin)
            }
        }
        
        return uniqueCoins
    }
    
    func searchCrypto(query: String) {
        if !query.isEmpty {
            filteredCryptos = self.filteredCryptos.filter { crypto in
                (crypto.name ?? "").lowercased().contains(query.lowercased()) ||
                (crypto.symbol ?? "").lowercased().contains(query.lowercased())
            }
        }else{
            self.filteredCryptos = self.allCryptos
        }
        self.updateData?(self.filteredCryptos)
    }
}

extension CryptoListViewModel {
    // Returns the number of rows in the table
    func numberOfRowsInSection() -> Int {
        return self.filteredCryptos.count
    }
    
    // Return the CoinModel object of an indexPath
    func cellForRowAt(indexPath: IndexPath) -> CoinModel? {
        return self.filteredCryptos[indexPath.row]
    }
}
