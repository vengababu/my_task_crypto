//
//  ViewController.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import UIKit

class CryptoListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = CryptoListViewModel(dbService: DatabaseService(), apiService: APIService())
    private var filterSelectVw: FilterSelectionView?
    private var customNavBar: CustomNavigationBar?
    private var customSearchBar: CustomSearchBar?
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheUI()
        setupBindings()
    }

    
    private func setupBindings() {
        self.tableView.hideErrorMessage()
        makeCryptoListApi()
        viewModel.updateData = {[weak self] content in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.showActivityIndicator(false)
                self?.refreshControl?.endRefreshing()
                self?.handleErrorMessage()
            }
        }
    }

    func makeCryptoListApi() {
        tableView.showActivityIndicator(true)
        viewModel.fetchCryptoList()
    }
    
    
    func handleErrorMessage(){
        if self.viewModel.filteredCryptos.count == 0 {
            if self.viewModel.allCryptos.count == 0 {
                self.tableView.showErrorMessage(errMessage: noData) // not data
            }else{
                self.tableView.showErrorMessage(errMessage: noSearchData) //filter data empty
            }
        }else{
            self.tableView.hideErrorMessage()
        }
    }
    
    
    func onTapFilter() {
        guard let filterView = self.filterSelectVw else { return }
        if filterView.isHidden {
            filterView.isHidden = false
            self.filterSelectVw?.toggleFilterViewVisibility(isHidden: false)
        } else {
            self.filterSelectVw?.toggleFilterViewVisibility(isHidden: true, completion: {
                filterView.isHidden = true
            })
        }
    }
    
    func onTapSearch() {
        self.filterSelectVw?.isHidden = true
        self.customSearchBar?.isHidden.toggle()
        if !(self.customSearchBar?.isHidden ?? false) {
            self.customSearchBar?.becomeTextFirstResponder()
        }
        self.resetFilter()
    }
    
    func resetFilter() {
        self.customNavBar?.filterDot?.isHidden = true
        self.filterSelectVw?.resetFilters()
        self.viewModel.applyFilter(selectedFilterOptions: [])
    }
    
    // Action to handle refresh
    @objc func handleRefresh() {
        self.refreshControl?.endRefreshing()
        self.resetFilter()
        self.customSearchBar?.clearSearchText()
        self.customSearchBar?.isHidden = true
        // Simulate a network call or some task that fetches new data
        self.makeCryptoListApi()
    }
}

// MARK: - TableView DataSource & Delegate
extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCoinCell", for: indexPath) as? CustomCoinCell
        let crypto = viewModel.cellForRowAt(indexPath: indexPath)
        cell?.configureCell(with: crypto)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Search Bar Delegate
extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCrypto(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCrypto(query: "")
    }
}

extension CryptoListViewController: SearchBarDelegate {
    func searchTextDidChange(to text: String?) {
        self.viewModel.searchCrypto(query: text ?? "")
    }
}


//UI Setup
extension CryptoListViewController {
    
    func setupTheUI() {
        setupNavigationBar()
        setupTableView()
        addFilterView()
        setUpSearchBar()
    }
    
    private func setupTableView() {
        // TableView
        tableView.register(CustomCoinCell.self, forCellReuseIdentifier: "CustomCoinCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        // Attach the refresh control to the table view
        tableView.refreshControl = refreshControl
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.customNavBar!.topAnchor, constant: 64),            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationBar() {
        // Initialize Custom Navigation Bar
        let navBarHeight: CGFloat = 64
        let title = "Crypto List"
        let buttonImages = ["search", "filter"]
        
        // Create the custom navigation bar and set the callback for button taps
        customNavBar = CustomNavigationBar(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navBarHeight),
            title: title,
            rightButtonImageNames: buttonImages
        ) { [weak self] index in
            switch index {
            case 0:
                if NetworkMonitor.shared.isConnected || (self?.viewModel.filteredCryptos ?? []).count > 0 {
                    self?.onTapSearch()
                }
                break
            case 1:
                if NetworkMonitor.shared.isConnected || (self?.viewModel.filteredCryptos ?? []).count > 0 {
                    self?.onTapFilter()
                }
                break
            default:
                break
            }
        }
        
        // Add the navigation bar to the view
        customNavBar?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar!)
        
        // Setup Constraints
        NSLayoutConstraint.activate([
            customNavBar!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar!.heightAnchor.constraint(equalToConstant: navBarHeight)
        ])
        // Hide the default navigation bar and set the background color
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.blue  // Customize if needed
    }
    
    
    // Configures the search bar and its constraints.
    func setUpSearchBar() {
        self.customSearchBar = CustomSearchBar(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 50),
                                               delegate: self,
                                               cancelButtonAction: {
            self.customSearchBar?.clearSearchText()
            self.onTapSearch()
        })
        self.customSearchBar?.backgroundColor = UIColor.blue
        self.view.addSubview(self.customSearchBar!)
        self.customSearchBar?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSearchBar!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customSearchBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSearchBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customSearchBar!.heightAnchor.constraint(equalToConstant: 64)
        ])
        self.customSearchBar?.isHidden = true
    }
    
    
    // Sets up the Filter view with Done Button to apply the filter and showing the DOT.
    private func addFilterView() {
        self.filterSelectVw = FilterSelectionView(frame: self.view.bounds)
        self.filterSelectVw?.translatesAutoresizingMaskIntoConstraints = false
        self.filterSelectVw?.backgroundColor = .lightGray.withAlphaComponent(0.3)
        self.view.addSubview(self.filterSelectVw!)
        self.filterSelectVw?.isHidden = true
        
        NSLayoutConstraint.activate([
            filterSelectVw!.topAnchor.constraint(equalTo: tableView.topAnchor),
            filterSelectVw!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterSelectVw!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterSelectVw!.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
        self.filterSelectVw?.onFiltersSelected = { [weak self] selectedFilterOptions in
            self?.customNavBar?.filterDot?.isHidden = selectedFilterOptions.isEmpty
            self?.viewModel.applyFilter(selectedFilterOptions: selectedFilterOptions)
        }
        self.filterSelectVw?.hideTheFilter = { [weak self] in
            self?.onTapFilter()
        }
    }
}
