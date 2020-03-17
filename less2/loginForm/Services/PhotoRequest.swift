//
//  PhotoRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire

class PhotosRequest {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func request () {
        let path = "/photos.getAll"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "v": "5.52",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("Запрос фотографий \(response.value ?? "")")
        }
        
        
    }
    
}
