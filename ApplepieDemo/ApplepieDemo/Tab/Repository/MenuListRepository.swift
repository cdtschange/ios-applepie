//
//  MenuListRepository.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit
import Applepie

class MenuListRepository: BaseRepository {
    func fetchMenus(type: MenuType) -> Promise<[MenuModel]> {
        switch type {
        case .uiComponent:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Navigation Bar", detail: "", url: "MenuListViewController", params: ["type": MenuType.navigationBar.rawValue, "title": "Navigation Bar"])
                    ]
                )
            }
        case .navigationBar:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Color Change", detail: "Change color of navigation bar when scrolling", url: "MenuListViewController", params: ["type": MenuType.scrollView.rawValue, "title": "ScrollView"])
                    ]
                )
            }
        default:
            return Promise(error: APError(statusCode: APStatusCode.badRequest.rawValue, message: "MenuType Error"))
        }
    }
}

enum MenuType: String {
    case none, uiComponent, scrollView, navigationBar
}
struct MenuModel {
    var title: String
    var detail: String
    var url: String
    var params: [String: Any]
}
