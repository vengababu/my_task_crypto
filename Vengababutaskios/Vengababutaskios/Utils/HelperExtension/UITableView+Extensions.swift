//
//  UITableView+Extensions.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 28/11/24.
//

import Foundation
import UIKit

extension UITableView {
    func showActivityIndicator(_ show: Bool) {
        var activityIndicator: UIActivityIndicatorView!
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width/2), y: (self.frame.size.height * 0.7), width: 50, height: 50))
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
        }
        activityIndicator.color = UIColor.blue
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        if show {
            activityIndicator.startAnimating()
            self.backgroundView = activityIndicator
        } else {
            activityIndicator.stopAnimating()
            self.backgroundView = nil
        }
    }
}
