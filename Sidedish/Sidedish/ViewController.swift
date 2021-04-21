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
    var fileManager = FileManagerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        self.collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        
        self.itemViewModel = ItemViewModel()
        self.headerViewModel = HeaderViewModel()
        self.itemViewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }.store(in: &fetchItemSubscription)
        
        self.itemViewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (imageDatas) in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }.store(in: &fetchImageSubscription)
        
        self.itemViewModel.errorHandler = { error in
            Toast(text: error).show()
        }
        
        self.itemViewModel.fetchItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemViewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else {
            return ItemCollectionViewCell()
        }
        
        
        let item = self.itemViewModel.items[indexPath.row]
        
//        guard let url = URL(string: item.image) else { return ItemCollectionViewCell() }

//        guard let imageData = fileManager.checkCacheData(with: url.lastPathComponent) else {
//            downloadImage(from: url, to: cell)
//            return cell
//        }
        cell.configure(model: item)
        
        guard let data = self.itemViewModel.images[indexPath.row] else { return ItemCollectionViewCell() }
        cell.configure(data: data)

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.nPrice ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.originalPrice.attributedText = attributeString
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.headerViewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! HeaderCollectionReusableView
        let tapRecognizer = TapToastGestureRecognize(target: self, action: #selector(makingHeaderToast(_:)))
        tapRecognizer.title = headerViewModel.titles[indexPath.section]
        tapRecognizer.countText = "\(itemViewModel.items.count)개 상품이 등록되어 있습니다."
        header.addGestureRecognizer(tapRecognizer)
        
        header.title.text = headerViewModel.titles[indexPath.section]
        header.countLabel.text = "\(itemViewModel.items.count)개 상품이 등록되어 있습니다."
        return header
    }
    
    @objc func makingHeaderToast(_ sender: TapToastGestureRecognize) {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedQuote = NSAttributedString(string: "\(sender.title)\n\(sender.countText)", attributes: attributes)
        Toast(attributedText: attributedQuote).show()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 130)
    }
    
    
    
}
