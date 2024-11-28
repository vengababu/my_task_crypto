//
//  FilterColVwCell.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 27/11/24.
//

import Foundation

import UIKit

class FilterColVwCell: UICollectionViewCell {
    
    // MARK: - Properties

    /// Label to display the filter's title
    private lazy var filterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.accessibilityLabel = "Filter Title"
        return label
    }()
    
    /// UIImageView to display a checkmark when the filter is selected
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        imageView.isHidden = true  // Initially hidden
        imageView.accessibilityLabel = "Checkmark Icon"
        return imageView
    }()
    
    /// StackView to arrange the checkmark and filter title horizontally
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [filterTitleLabel,checkmarkImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: - Setup Methods
    
    /// Setup the layout of the cell and constraints for the subviews
    private func setupCell() {
        contentView.addSubview(contentStackView)
        
        setupConstraints()
        contentView.applyDefaultStyle()  // Apply default styles to the contentView
    }
    
    /// Setup Auto Layout constraints for subviews
    private func setupConstraints() {
        // Constraints for the checkmark image (15x15)
        NSLayoutConstraint.activate([
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 15),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Constraints for the contentStackView (arranged view for checkmark and title label)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Data Population
    
    /// Populate the cell with data from the given `FilterModel` model
    /// - Parameter filter: The `FilterModel` object containing the filter data
    func configureCell(with filter: FilterModel) {
        filterTitleLabel.text = filter.title
        checkmarkImageView.isHidden = !filter.isSelected
        contentView.backgroundColor = filter.isSelected ? .lightGray : .white
        
        // Add accessibility support
        contentView.accessibilityLabel = filter.isSelected ? "Selected Filter" : "Unselected Filter"
        contentView.accessibilityHint = "Tap to select or deselect"
    }
}
