//
//  ItemViewModel.swift
//  Sidedish
//
//  Created by Issac on 2021/04/19.
//

import Foundation

class ItemViewModel {
    @Published var items: [SidedishItem]
    var errorHandler: ((String) -> ())?
    var sidedishProcessing: SidedishProcessing
    
    init() {
        self.items = [SidedishItem]()
        self.sidedishProcessing = SidedishProcessing()
    }
    
    func fetchItems() {
        let url = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan/main"
        self.sidedishProcessing.getItems(url: url) { (result) in
            switch result {
            case .success(let sidedishItems):
                self.items = sidedishItems
            case .failure(let error):
                print(error)
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
}
