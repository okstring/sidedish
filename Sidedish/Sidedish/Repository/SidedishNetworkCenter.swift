//
//  SidedishNetworkCenter.swift
//  Sidedish
//
//  Created by Issac on 2021/04/19.
//

import Foundation
import Alamofire

protocol Networkable {
    func fetchItems(url: String, completion: @escaping (Result<[SidedishItem], AFError>) -> ())
    func downloadImage(from url: URL, completion: @escaping ((Data) -> ()) )
}

class SidedishNetworkCenter: Networkable {
    func fetchItems(url: String, completion: @escaping (Result<[SidedishItem], AFError>) -> ()) {
        //MARK: - cache가 없으면
        AF.request(url).validate().responseDecodable(of: SidedishOfCategory.self) { (response) in
            switch response.result {
            case .success(let sidedishOfCategory):
                completion(.success(sidedishOfCategory.body) )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping ((Data) -> ()) ) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                #if DEBUG
                NSLog(error.localizedDescription)
                #endif
                return
            }
            guard let imageData = data else {
                return
            }
            completion(imageData)
        }.resume()
    }
}
