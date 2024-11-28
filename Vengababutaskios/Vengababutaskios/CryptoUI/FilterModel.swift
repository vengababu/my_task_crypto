//
//  FilterModel.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 26/11/24.
//

import Foundation

class FilterModel {
    var title: String
    var isSelected: Bool = false
    var mapIndex: Int
    
    init(title: String, isSelected: Bool = false, mapIndex: Int) {
        self.title = title
        self.isSelected = isSelected
        self.mapIndex = mapIndex
    }
}
