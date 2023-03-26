//
//  ViewController.swift
//

import UIKit
import Combine

enum AnimalType {
    case dog
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageStepper: UIStepper!
    
    var viewModel = AnimalViewModel()
    lazy var dataSource = makeDataSource()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        // configure collection view
        collectionView.delegate = self
        collectionView.dataSource = dataSource
//        collectionView.allowsSelection = false
        collectionView.register(UINib(nibName: AnimalCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: AnimalCollectionViewCell.reuseIdentifier)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    @IBAction func didTapPage(_ sender: UIStepper) {
        viewModel.page = Int(sender.value)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func bindViewModel() {
        viewModel.$page
            .print("vvv_$page")
            .receive(on: RunLoop.main)
            .sink { [weak self] page in
                self?.title = "ShelterAnimal Page: \(page)"
            }
            .store(in: &cancellable)
        
        viewModel.$animals
            .print("vvv_animals")
            .receive(on: RunLoop.main)
            .sink { [weak self] animals in
                print("vvv_applySnapshot")
                self?.applySnapshot(animals: animals)
                if !animals.isEmpty {
                    self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
            .store(in: &cancellable)
        
        viewModel.$isFetchingData
            .print("vvv_$isFetchingData")
            .receive(on: RunLoop.main)
            .sink { [weak self] isFetching in
                self?.pageStepper.isUserInteractionEnabled = !isFetching
            }
            .store(in: &cancellable)
    }
    
    private func configure<T: AnimalConfiguringCell>(_ cellType: T.Type, with animal: Animal, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: animal)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animal = dataSource.itemIdentifier(for: indexPath)!
        print(animal)
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension ViewController {
    func makeDataSource() -> UICollectionViewDiffableDataSource<AnimalType, Animal> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, animal in
            let cell = self?.configure(AnimalCollectionViewCell.self, with: animal, for: indexPath)
            
            self?.viewModel.getImage(animal: animal, completion: { [weak cell] (image) in
                cell?.imageView.image = image
            })
            return cell
        }
    }
    
    func applySnapshot(animals: [Animal], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<AnimalType, Animal>()
        snapshot.appendSections([.dog])
        snapshot.appendItems(animals, toSection: .dog)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}
