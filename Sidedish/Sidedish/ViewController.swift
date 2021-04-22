//
//  ViewController.swift
//  Sidedish
//
//  Created by Issac on 2021/04/19.
//

import UIKit
import Combine
import Toaster
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var itemViewModel: ItemViewModel!
    var headerViewModel: HeaderViewModel!
    
    var fetchItemSubscription = Set<AnyCancellable>()
    var fetchImageSubscription = Set<AnyCancellable>()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SidedishItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SidedishItem>
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemViewModel = ItemViewModel()
        self.headerViewModel = HeaderViewModel()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        itemListDidLoad()
        headerProvide()

        self.itemViewModel.errorHandler = { error in
            Toast(text: error).show()
        }
        
    }
    
    private func headerProvide() {
        self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                         for: indexPath) as? HeaderCollectionReusableView
            let title = Section.allCases[indexPath.section].title
            guard let itemCount = self.itemViewModel.checkItemCount(of: indexPath.section) else { return nil }
            header?.configure(title: title, count: itemCount)
            return header
        }
        
    }
    
    private func itemListDidLoad() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { (section) in
            self.itemViewModel.fetchItems(of: section) { (sidedishItems) in
                snapshot.appendItems(sidedishItems, toSection: section)
                self.dataSource.apply(snapshot)
            }
        }
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(collectionView: self.collectionView) { (collectionView, indexPath, sidedishItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return nil }
            cell.configure(model: sidedishItem)
//            cell.configure(data: <#T##Data#>)
            return cell
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 130)
    }
}
