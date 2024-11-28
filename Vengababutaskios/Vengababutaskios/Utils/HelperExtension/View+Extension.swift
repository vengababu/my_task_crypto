//
//  ViewExtension.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 27/11/24.
//

import UIKit

extension UIView {
    
    /// Applies default styling to the view with customizable options for borders, corner radius, and shadow.
    /// - Parameters:
    ///   - borderColor: The color of the border (default: `.black`).
    ///   - borderWidth: The width of the border (default: `1`).
    ///   - cornerRadius: The corner radius of the view (default: `14`).
    ///   - shadowColor: The shadow color (default: `.black`).
    ///   - shadowOpacity: The opacity of the shadow (default: `0.2`).
    ///   - shadowOffset: The offset of the shadow (default: `(0, 2)`).
    ///   - shadowRadius: The blur radius of the shadow (default: `4`).
    ///   - animate: A boolean indicating if the style changes should be animated (default: `false`).
    func applyDefaultStyle(
        borderColor: UIColor = .black,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 14,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.2,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 4,
        animate: Bool = false
    ) {
        // Apply border and corner radius
        if layer.borderColor != borderColor.cgColor {
            layer.borderColor = borderColor.cgColor
        }
        if layer.borderWidth != borderWidth {
            layer.borderWidth = borderWidth
        }
        if layer.cornerRadius != cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        
        // Apply shadow only if needed
        if layer.shadowColor != shadowColor.cgColor {
            layer.shadowColor = shadowColor.cgColor
        }
        if layer.shadowOpacity != shadowOpacity {
            layer.shadowOpacity = shadowOpacity
        }
        if layer.shadowOffset != shadowOffset {
            layer.shadowOffset = shadowOffset
        }
        if layer.shadowRadius != shadowRadius {
            layer.shadowRadius = shadowRadius
        }
        
        // Optionally animate the shadow and border changes
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layer.shadowOpacity = shadowOpacity
                self.layer.shadowOffset = shadowOffset
                self.layer.shadowRadius = shadowRadius
            }
        }
    }
    
    
    
    func showErrorMessage(errMessage: String) {
        // Create a UILabel for the error message
        let errorLabel = UILabel()
        errorLabel.text = errMessage
        errorLabel.font = UIFont.boldSystemFont(ofSize: 18)
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red // Set the color you want for error messages
        errorLabel.numberOfLines = 0 // Allow multiple lines for the message
        
        // Add extra styling if needed (e.g., background color, padding, etc.)
        errorLabel.backgroundColor = .clear // Adjust based on your UI needs
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add errorLabel as the background view for UITableView or UICollectionView
        if let tableView = self as? UITableView {
            DispatchQueue.main.async {
                // Add errorLabel as the background view
                tableView.backgroundView = errorLabel
                
                // Set constraints to center the label in the table view
                NSLayoutConstraint.activate([
                    errorLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                    errorLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
                    errorLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 20),
                    errorLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -20)
                ])
            }
        }
        
        if let collectionView = self as? UICollectionView {
            DispatchQueue.main.async {
                collectionView.backgroundView = errorLabel
                
                // Set constraints to center the label in the collection view
                NSLayoutConstraint.activate([
                    errorLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                    errorLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
                    errorLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 20),
                    errorLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -20)
                ])
            }
        }
    }
    
    func hideErrorMessage() {
        DispatchQueue.main.async {
            if let tableView = self as? UITableView {
                if let backgroundView = tableView.backgroundView as? UILabel {
                    backgroundView.removeFromSuperview()
                    tableView.backgroundView = nil
                }
            }
            
            if let collectionView = self as? UICollectionView {
                if let backgroundView = collectionView.backgroundView as? UILabel {
                    backgroundView.removeFromSuperview()
                    collectionView.backgroundView = nil
                }
            }
        }
    }
    
}

