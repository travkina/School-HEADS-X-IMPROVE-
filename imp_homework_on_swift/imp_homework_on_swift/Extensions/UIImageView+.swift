//
//  UIImageView+.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import UIKit
import Alamofire

extension UIImageView {
    public func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else { return }
  
        DispatchQueue.global(qos: .userInitiated).async {
                AF.request(imageURL, method: HTTPMethod.get).response { (response) in
                    guard response.error == nil,
                          let data = response.data
                    else {
                        print("UIImageView_error: \(response.error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data, scale:1)
                    }
                }
            }
    }
}

