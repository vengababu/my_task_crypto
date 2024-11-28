//
//  CustomCoinCell.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation
import UIKit

class CustomCoinCell: UITableViewCell {

    // UILabel for displaying the Coin's name (e.g., Bitcoin, Ethereum)
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0 // Allows for multi-line text if necessary
        return label
    }()
    
    // UILabel for displaying the Coin's symbol (e.g., BTC, ETH)
    private lazy var coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0 // Allows for multi-line text if necessary
        return label
    }()
    
    // UIImageView to display the Coin's image or icon (e.g., Bitcoin logo)
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit  // Ensures the image scales proportionally
        imageView.layer.cornerRadius = 12.5  // Rounded corners for the image view
        return imageView
    }()
    
    // UIImageView to display a tag icon (e.g., "new", "hot", etc.)
    private lazy var tagIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // UIStackView to stack the coinNameLabel and coinSymbolLabel vertically
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinNameLabel, coinSymbolLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    // UIView to display a separator line at the bottom of the cell for visual separation
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    // Initialization method when creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(labelsStackView)
        contentView.addSubview(tagIconImageView)
        contentView.addSubview(coinImageView)
        contentView.addSubview(separatorLine)
        
        // Setup Auto Layout constraints for subviews
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Function to set up Auto Layout constraints for the subviews
    private func setupViewConstraints() {
        // Constraints for the labelsStackView (coinNameLabel and coinSymbolLabel stacked vertically)

        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelsStackView.trailingAnchor.constraint(equalTo: coinImageView.leadingAnchor, constant: -10)
        ])
        
        // Constraints for the tagIconImageView (tag icon)

        NSLayoutConstraint.activate([
            tagIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            tagIconImageView.widthAnchor.constraint(equalToConstant: 25),
            tagIconImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // Constraints for the coinImageView (coin icon)
        NSLayoutConstraint.activate([
            coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 25),
            coinImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // Constraints for the separatorLine (bottom separator line)
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
   
    // Function to populate the cell with data from a CoinResponseModel object
    func configureCell(with item: CoinModel?) {
        // Set the coin name
        coinNameLabel.text = item?.name ?? ""
        
        // Set the coin symbol
        coinSymbolLabel.text = item?.symbol ?? ""
        
        // Show or hide the tag icon based on the 'isTagShown' property
        tagIconImageView.isHidden = !(item?.isTagShown ?? false)
        tagIconImageView.image = (item?.isTagShown ?? false) ? UIImage(named: "coinNewTag") : nil
        
        // Set the background color of the coin image (e.g., to indicate activity)
        coinImageView.backgroundColor = item?.bgColor ?? UIColor.clear
        
        // Set the coin image if available; otherwise, hide the image and tag
        if let imageName = item?.imageName, !imageName.isEmpty {
            coinImageView.image = UIImage(named: imageName)
        } else {
            coinImageView.image = nil
            tagIconImageView.isHidden = true
            tagIconImageView.image = nil
        }
        
        // Set the background color of the contentView based on the 'isActive' status
        contentView.backgroundColor = (item?.isActive ?? false) ? .white : UIColor(named: "disabledColor_cccccc")
    }
}
