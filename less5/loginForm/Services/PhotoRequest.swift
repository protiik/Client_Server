//
//  PhotoRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class PhotosVK: Object {
    @objc dynamic var photo = String()
}

class DataBasePhotos {
    func save( photos: [PhotosVK] ) throws {
        let realm = try Realm()
        realm.beginWrite()
        realm.add(photos)
        try realm.commitWrite()
    }
    
    func photos() -> [PhotosVK] {
        do {
            let realm = try Realm()
            let objects = realm.objects(PhotosVK.self)
            return Array(objects)
        }
        catch {
            return []
        }
    }
}

protocol PhotosServiceRequest {
    func loadData (completion: @escaping ([PhotosVK]) -> Void)
}

protocol PhotosParser {
    func parse (data: Data) -> [PhotosVK]
}

class SwiftyJSONParserPhotos: PhotosParser {
    func parse(data: Data) -> [PhotosVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> PhotosVK in
                let photos = PhotosVK()
                let sizes = item["sizes"].arrayValue
                if let first = sizes.first{
                    photos.photo = first["url"].stringValue
                }
                
                return photos
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class PhotosRequest: PhotosServiceRequest {
    
    let db: DataBasePhotos = .init()
    
    let parser: PhotosParser
    
    init(parser: PhotosParser) {
        self.parser = parser
    }
    
    let userId = Session.shared.userId
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func loadData (completion: @escaping ([PhotosVK]) -> Void) {
        let path = "/photos.getAll"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "owner_id": userId,
            "v": "5.103",
            "access_token": apiKey
        ]
        print("\(userId)")
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [completion] (response) in
            guard let data = response.data else { return }
            
            let photos: [PhotosVK] = self.parser.parse(data: data)
            do{
                try self.db.save(photos:photos)
//                print(self.db.photos())
            }
            catch {
                print("error db")
            }
            completion(photos)
        }
        
    }
    
}
