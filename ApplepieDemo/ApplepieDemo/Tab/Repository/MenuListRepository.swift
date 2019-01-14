//
//  MenuListRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/14.
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
                        MenuModel(title: "Navigation Bar", detail: "", url: "MenuListViewController", params: ["type": MenuType.navigationBar.rawValue, "title": "Navigation Bar"], callback: nil)
                    ]
                )
            }
        case .data:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Crash", detail: "", url: "MenuListViewController", params: ["type": MenuType.crash.rawValue, "title": "Crash"], callback: nil)
                    ]
                )
            }
        case .crash:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "NSInvalidArgumentException", detail: "非法参数异常", url: "", params: [:]) {
                            let a: String? = nil
                            print(a!)
                        },
                        MenuModel(title: "NSRangeException", detail: "越界异常", url: "", params: [:]) {
                            let a = [1, 2, 3]
                            print(a[3])
                        },
                        MenuModel(title: "NSGenericException", detail: "通用异常", url: "", params: [:]) {
                            CrashFunction.invokeGenericException()
                        },
                        MenuModel(title: "NSMallocException", detail: "内存分配异常", url: "", params: [:]) {
                            let data = NSMutableData(capacity: 1)
                            data?.increaseLength(by: 1844674407370955161)
                        },
                        MenuModel(title: "NSFileHandleOperationException", detail: "文件处理异常", url: "", params: [:]) {
                            let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
                            let filePath = (cacheDir as NSString?)!.appendingPathComponent("1.txt")
                            if !FileManager.default.fileExists(atPath: filePath) {
                                let str1 = "hello1"
                                let data1 = str1.data(using: .utf8)
                                FileManager.default.createFile(atPath: filePath, contents: data1, attributes: nil)
                            }
                            let fileHandle = FileHandle(forReadingAtPath: filePath)
                            fileHandle?.seekToEndOfFile()
                            let str2 = "hello2"
                            let data2 = str2.data(using: .utf8)
                            fileHandle?.write(data2!)
                            fileHandle?.closeFile()
                        }
                    ]
                )
            }
        case .navigationBar:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Color Gradual Change", detail: "Change color of navigation bar when scrolling", url: "NavigatinBarColorScrollViewController", params: [:], callback: nil)
                    ]
                )
            }
        default:
            return Promise(error: APError(statusCode: APStatusCode.badRequest.rawValue, message: "MenuType Error"))
        }
    }
}

enum MenuType: String {
    case none, uiComponent, data, scrollView, navigationBar, crash
}
struct MenuModel {
    var title: String
    var detail: String
    var url: String
    var params: [String: Any]
    var callback: (() -> Void)?
}
