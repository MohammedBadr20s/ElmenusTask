//
//  GetServices.swift
//  elmenusTask
//
//  Created by D-TAG on 1/24/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class GetServices {
    static let shared = GetServices()
    //MARK:- GET Tags
    func getTags(pageNumber: Int) -> Observable<[Tag]> {
        return Observable.create({ (observer) -> Disposable in
            let url = ConfigURLs.getTags + "\(pageNumber)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    do {
                        let TagsData = try JSONDecoder().decode(TagsModel.self, from: response.data!)
                        if let tags = TagsData.tags {
                            print(tags)
                            observer.onNext(tags)
                        }
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
                })
            return Disposables.create()
        })
    }//END of Func Get tags
    
    //MARK:- FUNC Get Items
    func getItems(tagName: String) -> Observable<[Item]> {
        return Observable.create({ (observer) -> Disposable in
            let url = (ConfigURLs.getItems + "\(tagName)").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    do {
                        let ItemsData = try JSONDecoder().decode(ItemsModel.self, from: response.data!)
                        if let Items = ItemsData.items {
                            print(Items)
                            observer.onNext(Items)
                        }
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
                })
            return Disposables.create()
        })
    }//END of FUNC Get Items
}
