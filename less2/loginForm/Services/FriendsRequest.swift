//
//  FriendsRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire

class FriendRequest {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func request () {
        let path = "/friends.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "v": "5.52",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("Запрос друзей \(response.value ?? "")")
        }
        
//        Alamofire.request("https://api.vk.com/method/friends.get?v=5.52&access_token=813c1c16e28b5c1ee4876f3b65e8260a8626dbd18a6f5d06faa9db78225b90b00594512ad33a92c3bf0a0").responseJSON { response in
//            print(response.value)
        }

    }
