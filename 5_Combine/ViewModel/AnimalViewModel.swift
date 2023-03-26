//
//  AnimalViewModel.swift
//  CombinePractice
//
//  Created by 金融研發一部-楊雅婷 on 2022/12/22.
//

import UIKit
import Combine

class AnimalViewModel {
    @Published var animals = [Animal]()
    @Published var page = 0
    @Published var isFetchingData = false
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.initBinding()
    }
    
    private func initBinding(){
        $page
            .print("vvv_$page")
            .sink { [weak self] page in
                self?.fetchData(for: page)
            }
            .store(in: &cancellable)
    }

    
    func fetchData(for page: Int) {
        self.isFetchingData = true
        AnimalService.fetchData(for: UInt(page)) { [weak self] result in
            switch result {
            case .success(let animals):
                print("vvv_fetchData:\(animals)")
                self?.animals = animals
            case .failure(let error):
                print("*** fetch data error: \(error.localizedDescription) ***")
            }
            
            self?.isFetchingData = false
        }
    }
    
    func getImage(animal: Animal, completion: ((UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: animal.albumFile) {
            ImageCache.publicCache.load(url: imageURL, item: animal) { (item, image) in
                if let img = image, img != item.image, animal.animalId == item.animalId {
                    completion?(img)
                }
            }
        }
    }
}
