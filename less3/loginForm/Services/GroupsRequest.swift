//
//  GroupsRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GroupsVK {
    var id = Int()
    var name = String()
    var photo = String()
}

protocol GroupsServiceRequest {
    func loadData (completion: @escaping ([GroupsVK]) -> Void)
}

protocol GroupsParser {
    func parse (data: Data) -> [GroupsVK]
}

class SwiftyJSONParserGroups: GroupsParser {
    func parse(data: Data) -> [GroupsVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> GroupsVK in
                var groups = GroupsVK()
                groups.id = item["id"].intValue
                groups.name = item["name"].stringValue
                groups.photo = item["photo_50"].stringValue

                return groups
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class GroupsRequest: GroupsServiceRequest {
    
    let parser: GroupsParser
    
    init(parser: GroupsParser) {
        self.parser = parser
    }
    
    func loadData(completion: @escaping ([GroupsVK]) -> Void) {
        let baseURL = "https://api.vk.com/method"
        let apiKey = Session.shared.token
        
        let path = "/groups.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "v": "5.52",
            "access_token": apiKey,
            "extended": 1
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [completion] (response) in
            guard let data = response.data else { return }
            
            let groups: [GroupsVK] = self.parser.parse(data: data)
//            print(groups)
            completion(groups)
        }
        
    }
    
}
