//
//  Array+Extentions.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/8/24.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

