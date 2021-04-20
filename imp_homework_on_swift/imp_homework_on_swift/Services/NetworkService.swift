//
//  NetworkService.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import Foundation
import Alamofire

struct NetworkConstants {
    struct URLString {
        static let planetList = "https://rickandmortyapi.com/api/location"
    }
}

protocol ListNetworkService {
    func getPlanetLits(URL: String, onRequestComleted: @escaping ((RespondsModel?, Error?)->()))
}

class NetworkService: ListNetworkService {
    
    func getPlanetLits(URL: String,
                       onRequestComleted: @escaping ((RespondsModel?, Error?) -> ())) {
        performRequest(urlString: URL,
                       method: HTTPMethod.get,
                       onRequestComleted: onRequestComleted)
    }

    private func performRequest<T: Decodable>(urlString: String,
                                                              method: HTTPMethod,
                                                              onRequestComleted: @escaping ((T?, Error?)->())) {
           DispatchQueue.global().async {
               DispatchQueue.main.async {
                    AF.request(urlString,
                               method: method,
                               encoding: JSONEncoding.default).response { (responseData) in
                                guard responseData.error == nil,
                                      let data = responseData.data
                                else {
                                    onRequestComleted(nil, responseData.error)
                                    return
                                }
                                do {
                                    let decodedValue: T = try JSONDecoder().decode(T.self, from: data)
                                    onRequestComleted(decodedValue, nil)
                                }
                                catch (let error) {
                                    print("Response parsing error: \(error.localizedDescription)")
                                    onRequestComleted(nil, error)
                                }
                               }
              }
         }
        }
}
