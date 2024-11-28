//
//  CoinModel.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation
import UIKit

class CoinModel: Codable, Equatable {
    let name: String?
    let symbol: String?
    let isNew: Bool
    let isActive: Bool
    let type: String?
    var imageName: String?
    var bgColor: UIColor = .clear
    var isTagShown = false
    
    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
    
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.symbol == rhs.symbol
    }
    
    init(name: String?, symbol: String?, isNew: Bool, isActive: Bool, type: String?, imageName: String? = nil, isTagShown: Bool = false) {
        self.name = name
        self.symbol = symbol
        self.isNew = isNew
        self.isActive = isActive
        self.type = type
        self.imageName = imageName
        self.isTagShown = isTagShown
    }

}
