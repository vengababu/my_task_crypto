//
//  VengababutaskiosTests.swift
//  VengababutaskiosTests
//
//  Created by Venga Babu on 26/11/24.
//

import XCTest
@testable import Vengababutaskios

final class VengababutaskiosTests: XCTestCase {
    var viewModel: CryptoListViewModel!
    var mockCoins: [CoinModel]!
    
    override func setUpWithError() throws {
        viewModel = CryptoListViewModel(dbService: DatabaseService(), apiService: APIService())
        mockCoins = [
            CoinModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            CoinModel(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true,  type: "coin"),
            CoinModel(name: "Tether", symbol: "USDT", isNew: false, isActive: false, type: "token")
        ]
        viewModel.filteredCryptos = mockCoins
        viewModel.allCryptos = mockCoins
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    override func tearDown() {
        viewModel = nil
        mockCoins = nil
        super.tearDown()
    }
    
    func testFetchCoins() {
        let expectation = XCTestExpectation(description: "Fetch coins")
        viewModel.updateData = {[weak self] content in
            XCTAssertFalse((self?.viewModel.filteredCryptos ?? []).isEmpty, "Filtered coins should not be empty")
            expectation.fulfill()
        }
        viewModel.fetchCryptoList()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFilterByActive() {
        let filterSelected =  FilterModel(title: activeCoins, mapIndex: 1)
        filterSelected.isSelected = true
        viewModel.applyFilter(selectedFilterOptions: [filterSelected])
        XCTAssertEqual(viewModel.filteredCryptos.count, 2, "Only active coins should be filtered")
    }
    
    func testFilterByNew() {
        let filterSelected =  FilterModel(title: onlyCoins, mapIndex: 2)
        let filterSelected1 = FilterModel(title: activeCoins, mapIndex: 1)
        filterSelected.isSelected = true
        filterSelected1.isSelected = true
        viewModel.applyFilter(selectedFilterOptions: [filterSelected,filterSelected1])
        XCTAssertEqual(viewModel.filteredCryptos.count, 2, "new coins and active coins should be filtered")
    }
    
    func testFilterByType() {
        viewModel.searchCrypto(query: "Tether")
        XCTAssertEqual(viewModel.filteredCryptos.count, 1, "Only name or symbol query should be filtered")
    }
    
    func testSearch() {
        viewModel.searchCrypto(query: "BTC")
        XCTAssertEqual(viewModel.filteredCryptos.count, 1, "Search should return coins matching the query")
    }
}
