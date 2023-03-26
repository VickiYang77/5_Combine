//
//  AnimalConfiguringCell.swift
//

import Foundation

protocol AnimalConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with animal: Animal)
}
