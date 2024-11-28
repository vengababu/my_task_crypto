//
//  CustomNavigationBar.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 27/11/24.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {

    // MARK: - Properties

    private var titleLabel: UILabel!
    private var rightButtons: [UIButton] = []
    var filterDot: UIView?

    var rightButtonTapped: ((Int) -> Void)?
    
    // MARK: - Initializer

    init(frame: CGRect,
         title: String? = nil,
         rightButtonImageNames: [String]? = nil,
         backgroundColor: UIColor = .blue,
         titleTextColor: UIColor = .white,
         buttonCallback: ((Int) -> Void)? = nil,
         buttonsShouldShow: Bool = true) {

        super.init(frame: frame)

        self.backgroundColor = backgroundColor
        self.rightButtonTapped = buttonCallback
        
        setupTitleLabel(with: title, textColor: titleTextColor)
        setupRightButtons(with: rightButtonImageNames, showButtons: buttonsShouldShow, titleTextColor: titleTextColor)
    }

    // MARK: - Setup Methods

    private func setupTitleLabel(with title: String?, textColor: UIColor) {
        guard let title = title else { return }
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Title constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        

    }

    private func setupRightButtons(with imageNames: [String]?, showButtons: Bool, titleTextColor: UIColor) {
        guard let imageNames = imageNames else { return }
        
        for (index, imageName) in imageNames.enumerated() {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: imageName), for: .normal)
            button.tintColor = titleTextColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isHidden = !showButtons  // Set the initial visibility based on the flag
            addSubview(button)
            rightButtons.append(button)
            
            configureButtonConstraints(button, at: index)
            configureButtonAction(button, at: index)
            
            if index == 1 {
                setupFilterDot(for: button)
            }
        }
 
    }

    private func configureButtonConstraints(_ button: UIButton, at index: Int) {
        // Position the buttons in a row
        if index == 0 {
            button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        } else {
            button.rightAnchor.constraint(equalTo: rightButtons[index - 1].leftAnchor, constant: -15).isActive = true
        }

        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func configureButtonAction(_ button: UIButton, at index: Int) {
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    private func setupFilterDot(for button: UIButton) {
        filterDot = UIView()
        filterDot?.backgroundColor = .red
        filterDot?.layer.cornerRadius = 2
        filterDot?.clipsToBounds = true
        filterDot?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterDot!)

        // Set up filter dot constraints
        guard let filterDot = filterDot else { return }
        NSLayoutConstraint.activate([
            filterDot.widthAnchor.constraint(equalToConstant: 4),
            filterDot.heightAnchor.constraint(equalToConstant: 4),
            filterDot.topAnchor.constraint(equalTo: button.topAnchor, constant: -5),
            filterDot.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5)
        ])
        filterDot.isHidden = true
    }

    // MARK: - Public Methods

    /// Toggle visibility of right-side buttons
    func setRightButtonsVisibility(shouldShow: Bool) {
        rightButtons.forEach { $0.isHidden = !shouldShow }
    }

    /// Update title text
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    /// Show/hide the filter dot
    func toggleFilterDot(isVisible: Bool) {
        filterDot?.isHidden = !isVisible
    }

    // MARK: - Action Methods

    @objc private func buttonTapped(_ sender: UIButton) {
        rightButtonTapped?(sender.tag)
    }

    // MARK: - Required Initializer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
