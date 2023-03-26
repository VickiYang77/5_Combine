//
//  AnimalCollectionViewCell.swift
//

import UIKit

class AnimalCollectionViewCell: UICollectionViewCell, AnimalConfiguringCell {
    static let reuseIdentifier = "AnimalCollectionViewCell"
    
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var bodyType: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var onReuse: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse?()
        imageView.image = UIImage(named: "Default.jpg")
    }
    
    func configure(with animal: Animal) {
        place.text = "地點: \(animal.place)"
        kind.text = "品種: \(animal.animalVariety)"
        sex.text = "性別: \(animal.sex)"
        bodyType.text = "體型: \(animal.bodytype)"
        color.text = "顏色: \(animal.colour)"
        imageView.image = animal.image ?? UIImage(named: "Default.jpg")
    }
}
