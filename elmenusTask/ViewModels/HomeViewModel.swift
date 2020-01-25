//
//  HomeViewModel.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import Foundation
import RxSwift

struct HomeViewModel {
    //MARK:- Properties
    var Tags  = PublishSubject<[Tag]>()
    var Items = PublishSubject<[Item]>()
    
    //MARK:- fetch Tags
    func fetchTags(tagsArr: [Tag]) {
        Tags.onNext(tagsArr)
    }
    //MARK:- Fetch Items
    func fetchItems(ItemsArr: [Item]) {
        Items.onNext(ItemsArr)

    }
    //MARK:- Get Tags From Services
    func getTags(PageNumber: Int) ->Observable<[Tag]> {
        return GetServices.shared.getTags(pageNumber: PageNumber)
    }
    //MARK:- Get Items From Services
    func getItems(tagName: String) -> Observable<[Item]> {
        return GetServices.shared.getItems(tagName: tagName)
    }
}
