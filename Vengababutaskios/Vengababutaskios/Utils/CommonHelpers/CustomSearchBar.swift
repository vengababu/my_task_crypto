//
//  CustomSearchBar.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 27/11/24.
//

import Foundation

import UIKit

// Protocol to handle search text changes
protocol SearchBarDelegate: AnyObject {
    func searchTextDidChange(to text: String?)
}

class CustomSearchBar: UIView {
    
    // MARK: - UI Elements
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = false
        textField.delegate = self
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search coin..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.addTarget(self, action: #selector(searchTextDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: SearchBarDelegate?
    var onCancelButtonTapped: (() -> Void)?
    
    // MARK: - Initializer
    
    init(frame: CGRect, placeholder: String = "Search coin..", textColor: UIColor = .white, backgroundColor: UIColor = .black.withAlphaComponent(0.5), delegate: SearchBarDelegate? = nil, cancelButtonAction: (() -> Void)? = nil) {
        super.init(frame: frame)
        self.delegate = delegate
        self.onCancelButtonTapped = cancelButtonAction
        setupUI(placeholder: placeholder, textColor: textColor, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI(placeholder: String, textColor: UIColor, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 4.0
        self.addSubview(containerView)
        
        // Setup search text field
        searchTextField.textColor = textColor
        searchTextField.placeholder = placeholder
        containerView.addSubview(searchTextField)
        
        // Setup cancel button
        cancelButton.tintColor = textColor
        self.addSubview(cancelButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            searchTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            searchTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        onCancelButtonTapped?()
        clearSearchText()
    }
    
    @objc private func searchTextDidChange(_ textField: UITextField) {
        delegate?.searchTextDidChange(to: textField.text)
    }
    
    // MARK: - Helper Methods
    
    // Clears the text in the search field
    func clearSearchText() {
        searchTextField.text = ""
        DispatchQueue.main.async {
            self.searchTextField.resignFirstResponder()
        }
    }
    

    // Makes the search text field the first responder
    func becomeTextFirstResponder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.searchTextField.becomeFirstResponder()
        }
    }
}

extension CustomSearchBar: UITextFieldDelegate {
    
    // Handles return key on keyboard, dismissing the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
