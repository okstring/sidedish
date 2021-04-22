//
//  ItemViewModel.swift
//  Sidedish
//
//  Created by Issac on 2021/04/19.
//

import Foundation

class ItemViewModel {
    @Published var items: [SidedishItem]
    var itemsTwo: [SidedishItem]
    var itemsThree: [SidedishItem]
    @Published var images: [Data?]
    var allItems: [[SidedishItem]]
    var errorHandler: ((String) -> ())?
    var sidedishProcessing: SidedishProcessing
    
    init() {
        self.items = [SidedishItem]()
        self.itemsTwo = [SidedishItem]()
        self.itemsThree = [SidedishItem]()
        self.allItems = [[SidedishItem]]()
        self.images = [Data?]()
        self.sidedishProcessing = SidedishProcessing()
    }
    
    func fetchItems(of path: Section, completion: @escaping ([SidedishItem]) -> ()) {
        let url = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan/\(path.rawValue)"
        self.sidedishProcessing.getItems(url: url) { (result) in
            switch result {
            case .success(let sidedishItems):
                self.items = sidedishItems
                self.images = Array(repeating: nil, count: sidedishItems.count)
                completion(sidedishItems)
            case .failure(let error):
                print(error)
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
    func checkItemCount(of section: Int) -> Int? {
        switch section {
        case 0: return items.count
        case 1: return itemsTwo.count
        case 2: return itemsThree.count
        default: return nil
        }
    }
    
    func fetchImage() {
        for (index, item) in self.items.enumerated() {
            guard let url = URL(string: item.image) else { return }
            DispatchQueue.global().async {
                self.sidedishProcessing.getImage(url: url) { (data) in
                    self.images[index] = data
                }
            }
        }
    }
}
