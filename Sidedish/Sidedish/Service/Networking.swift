//
//  Networking.swift
//  Sidedish
//
//  Created by Issac on 2021/04/20.
//

import Foundation
import Alamofire


class Networking {
//    func requestMainCagegiry(url: String, completion: @escaping (Result<Any, AFError>) -> ()) {
//        AF.request(url, method: .get,
//                   encoding: JSONEncoding.default,
//                   headers:  ["Content-Type":"application/json;charset=utf-8"] )
//            .validate()
//            .responseJSON(completionHandler: { (response) in
//                completion(response.result)
//            })
//    }
    
    func requestCategory<T: Decodable>(url: String, completion: @escaping (Result<T, AFError>) -> ()) {
        AF.request(url).validate().responseDecodable(of: T.self) { (response) in
            switch response.result {
            case .success(_):
                completion(response.result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping ((Data) -> ()) ) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
//            self.fileManager.write(fileName: url.lastPathComponent, image: data)
            completion(data)
        }.resume()
    }
}
