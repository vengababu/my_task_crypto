//
//  FilterSelectionView.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation
import UIKit

class FilterSelectionView: UIView {
    
    // Closure to notify when the user taps the 'Done' button, returning selected filter options
    var onFiltersSelected: (([FilterModel]) -> Void)?
    
    var hideTheFilter:(() ->Void)?
    
    private var containerView: UIView!
    private var bottomConstraint: NSLayoutConstraint!
    
    // UICollectionView to display the list of filter options
    private lazy var filterCollectionView: UICollectionView = {
        let layout = ColVwFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 2.0, bottom: 10, right: 2.0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.frame.width, height: 10), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 21, bottom: 10, right: 21)
        collectionView.backgroundColor = .clear
        collectionView.register(FilterColVwCell.self, forCellWithReuseIdentifier: "FilterColVwCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // Array of filter options with mapIndex to group related filters
    private var filterOptions: [FilterModel] = [
        FilterModel(title: activeCoins, mapIndex: 1),
        FilterModel(title: inactiveCoins, mapIndex: 1),
        FilterModel(title: onlyTokens, mapIndex: 2),
        FilterModel(title: onlyCoins, mapIndex: 2),
        FilterModel(title: newCoins, mapIndex: 3)
    ]

    // Initialization method for programmatically created views
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function to configure the layout and subviews
    private func setupView() {
        // Set up the container view
        containerView = UIView()
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .lightGray
        addSubview(containerView)
        
        //add gesture to hide the view when tapping outside of col view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)

        
        // Add collection view to container
        containerView.addSubview(filterCollectionView)
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 200)
        
        // Apply layout constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConstraint!,
            containerView.heightAnchor.constraint(equalToConstant: 200),

            filterCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            filterCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            filterCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
        
        // Reload collection view data after setting up
        reloadCollectionViewData()
    }
    
    // Action when 'Done' button is tapped to pass selected filters
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        hideTheFilter?()
    }
    
    // Reload the collection view data
    private func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.filterCollectionView.reloadData()
        }
    }
    
    // Reset all filters to their default (unselected) state
    func resetFilters() {
        filterOptions = filterOptions.map { filter in
            let updatedFilter = filter
            updatedFilter.isSelected = false
            return updatedFilter
        }
        reloadCollectionViewData()
    }

    // Function to animate showing or hiding the filter view
    func toggleFilterViewVisibility(isHidden: Bool, completion: (() -> Void)? = nil) {
        bottomConstraint.constant = isHidden ? 200 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
}

extension FilterSelectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    // Configure each cell in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterColVwCell", for: indexPath) as? FilterColVwCell else { return UICollectionViewCell() }
        let filter = filterOptions[indexPath.item]
        cell.configureCell(with: filter)
        return cell
    }
    
    // Handle filter selection/deselection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = filterOptions[indexPath.item]
        let mapIndex = selectedFilter.mapIndex
        
        // Deselect filter if it's already selected
        if selectedFilter.isSelected == true {
            filterOptions[indexPath.item].isSelected = false
        } else {
            // Deselect all filters in the same group
            for (index, filter) in filterOptions.enumerated() {
                if filter.mapIndex == mapIndex {
                    filterOptions[index].isSelected = false
                }
            }
            filterOptions[indexPath.item].isSelected = true
        }
        reloadCollectionViewData()
        let selectedFilters = filterOptions.filter { $0.isSelected }
        onFiltersSelected?(selectedFilters)
    }
    
    // Define the size of each collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let filterText = filterOptions[indexPath.item].title
        let textSize = (filterText as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let iconWidth: CGFloat = 20
        let padding: CGFloat = 16
        return CGSize(width: textSize.width + iconWidth + padding, height: 30)
    }
}

extension FilterSelectionView: UIGestureRecognizerDelegate {
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

       if let touchedView = touch.view, touchedView.isDescendant(of: self.filterCollectionView) {
            return false
        }else{
            return true
        }

    }
}
