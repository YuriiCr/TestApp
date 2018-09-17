//
//  InternetService.swift
//  TestApp
//
//  Created by Yurii Sushko on 14.09.2018.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InternetService {
    
    // MARK: Singlton
    
    static let shared = InternetService()
    private init() { }
    
    // MARK: Properties
    
    let baseUrl = "https://api.inrating.top/v1/users/posts/get"
    let likersPostUrl = "https://api.inrating.top/v1/users/posts/likers/all"
    let repostersUrl = "https://api.inrating.top/v1/users/posts/reposters/all"
    let commetnsUrl = "https://api.inrating.top/v1/users/posts/commentators/all"
    let marksUrl = "https://api.inrating.top/v1/users/posts/mentions/all"
    
    let token = Constants.token
    
    
    // MARK: Public Function
    
    func getLikersPost(block: @escaping (Int, [Person]) -> ()) {
      getPost(url: likersPostUrl, block: block)
    }
    
    func getReposters(block: @escaping (Int, [Person]) -> ()) {
      getPost(url: repostersUrl, block: block)
    }
    
    func getCommentators (block: @escaping (Int, [Person]) -> ()) {
       getPost(url: commetnsUrl, block: block)
    }
    
    func getMarks(block: @escaping (Int, [Person]) -> ()) {
        getPost(url: marksUrl, block: block)
    }
    
    func getPostInfo(block: @escaping (Int, Int) -> ()) {
        getPostInformation(url: baseUrl, block: block)
    }
    
    // MARK: Private Function
    
    private func getPost(url: String, block: @escaping (Int, [Person]) -> ()) {
        Alamofire.request(url, method: .post, parameters: Constants.params, encoding: URLEncoding.default, headers: [Constants.authorization : token]).responseJSON { (response) in
            if let response = response.value as? [String : Any] {
                guard let meta = response[Constants.meta] as? [String : Any] else { return }
                guard let count = meta[Constants.total] as? Int else { return }
                
                var persons = [Person]()
                
                guard let data = response[Constants.data] as? [Any] else { return }
                for item in data {
                    guard let item = item as? [String : Any] else { return }
                    guard let personName = item[Constants.nickname] as? String else { return }
                    var person = Person()
                    
                    guard let images = item[Constants.avatarImages] as? [String : Any] else { return }
                    let imageUrl = images[Constants.smallUrl] as? String
                    
                    person.name = personName
                    person.imagePath = imageUrl
                    
                    persons.append(person)
                }
                block(count, persons)

            }
            
        }
    }
    
    private func getPostInformation(url: String, block: @escaping (Int, Int) -> ()) {
        Alamofire.request(url, method: .post, parameters: Constants.params, encoding: URLEncoding.default, headers: [Constants.authorization : token]).responseJSON { (response) in
            guard let response = response.value as? [String : Any] else { return }
            guard let viewsCount = response[Constants.viewsCount] as? Int else { return }
            guard let bookMarksCount = response[Constants.bookMarsCount] as? Int else { return }
            block(viewsCount, bookMarksCount)
        }
    }
}

extension InternetService {
    
    private struct Constants {
        
        static let meta = "meta"
        static let total = "total"
        static let data = "data"
        static let authorization = "Authorization"
        static let nickname = "nickname"
        static let avatarImages = "avatar_image"
        static let smallUrl = "url_small"
        
        static let viewsCount = "views_count"
        static let bookMarsCount = "bookmarks_count"
        
        static let params = ["id": "2720"]
        
        static let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJmNGU5ZDA1MzU3MDI3MmFlMGZhZTMzM2Y4ZTY4ZWVlMWNiMzc0NmM0Mjg5NzI0ZTExNzJjM2Q4ODYzNDNkNDkyY2ZjZjI4Njg0NzQ0MGEwIn0.eyJhdWQiOiIyIiwianRpIjoiMmY0ZTlkMDUzNTcwMjcyYWUwZmFlMzMzZjhlNjhlZWUxY2IzNzQ2YzQyODk3MjRlMTE3MmMzZDg4NjM0M2Q0OTJjZmNmMjg2ODQ3NDQwYTAiLCJpYXQiOjE1MzY4MzE4ODcsIm5iZiI6MTUzNjgzMTg4NywiZXhwIjoxNTY4MzY3ODg3LCJzdWIiOiIzOCIsInNjb3BlcyI6W119.dRitRnoqNFS3xUgtLdLiDjDVVe7ZFNrh24Qm2ML9m-V7kZpgQgajArYoS44kMa1dz_MHUhq3pqk8SnAYIsULgfrOvewTUzmH1C92-yL64Uqnv7lqWizldX2fbJ2IbB8khOCtQ-CCNA_fGY_zEBJXLsOqr4Z00tbZE6fa0PX4Mu0SsuUakLeygXbXnKOmFyZmLJZWoXKpbqiSBU239nrcyqJftBon8DL1BAUuFiadap-gpVSXj8h6BX-FsJx5cgPHFiijIalcEgzOq4VCMkwbQE8xbTsmmxkZUOnM7oKab5inzl8EV5iUgcExeSbHT6k_phOkA7XUaR6PhVoKrSQTPcfdijhME1IHfPVDPGO0vhd6hKszRrhjEPEpoothBoB8ss0lmuCFURdxFv17q97rfpDn1OfO_Y3wYuRW2lqFAnw7sLd92CHjfONwQKswLDzwE4hiQhB8iS_UEbuL_UamNOiCLfjNnVWbVc9BvoReEa8jG4coc0Kv9VNJVWh3D_hGf8dLRZBd1a7zB6-nSpKGf0eAzB0_rBXsyBepjudC-5EFDjloJOxy1Mdruoq6mQa_tFcO99JRteUSd0CXHZO-CN4Bp4xND9kstdutjBn2UWT5xhNq_QRBmBsBDAwp647dUCyQofutN9GUlu2LxmhL0ojydazdND_d9rHtY9t-ndw"
    }
    
}
