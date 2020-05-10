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
                        MenuModel(title: "List View", detail: "", url: "MenuListViewController", params: ["type": MenuType.listView.rawValue, "title": "List View"], callback: nil),
                        MenuModel(title: "Web View", detail: "", url: "MenuListViewController", params: ["type": MenuType.webView.rawValue, "title": "Web View"], callback: nil),
                        MenuModel(title: "Indicator View", detail: "", url: "IndicatorViewController", params: ["title": "Indicator View"], callback: nil)
                    ]
                )
            }
        case .data:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Network", detail: "", url: "Network.NetworkViewController", params: ["title": "Network"], callback: nil),
                        MenuModel(title: "Cache", detail: "", url: "MenuListViewController", params: ["type": MenuType.cache.rawValue, "title": "Cache"], callback: nil),
                        MenuModel(title: "Device Info", detail: "", url: "DeviceInfoViewController", params: ["title": "Device Info"], callback: nil),
                        MenuModel(title: "Location", detail: "", url: "LocationViewController", params: ["title": "Location"], callback: nil),
                        MenuModel(title: "Crash", detail: "", url: "MenuListViewController", params: ["type": MenuType.crash.rawValue, "title": "Crash"], callback: nil),
                         MenuModel(title: "Core ML", detail: "", url: "MenuListViewController", params: ["type": MenuType.coreML.rawValue, "title": "Core ML"], callback: nil)
                        
                    ]
                )
            }
        case .listView:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "None Refresh List View", detail: "List View without refresh header or load more footer", url: "ListTypeViewController", params: ["title": "None Refresh List View", "type": "none"], callback: nil),
                        MenuModel(title: "Refresh Only List View", detail: "List View with only refresh header", url: "ListTypeViewController", params: ["title": "Refresh Only List View", "type": "refreshOnly"], callback: nil),
                        MenuModel(title: "Load More Only List View", detail: "List View with load more footer", url: "ListTypeViewController", params: ["title": "Load More Only List View", "type": "loadMoreOnly"], callback: nil),
                        MenuModel(title: "Refresh & Load More List View", detail: "List View with both refresh header and load more footer", url: "ListTypeViewController", params: ["title": "Refresh & Load More List View", "type": "both"], callback: nil)
                    ]
                )
            }
        case .webView:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Normal Web View Controller", detail: "Visit a website with a BaseWebViewController", url: "", params: [:]) {
                            APRouter.route(toUrl: "https://www.google.com")
                        },
                        MenuModel(title: "Web View Load From Html data", detail: "Load Html data in WebViewController", url: "", params: [:]) {
                            APRouter.route(toName: "SimpleWebViewController")
                        },
                        MenuModel(title: "Web View For Bridge", detail: "Custom Bridge for navtive & js call each other", url: "", params: [:]) {
                            APRouter.route(toName: "WebBridgeViewController")
                        }
                    ]
                )
            }
        case .cache:
            return Promise { sink in
                sink.fulfill(
                    [
                        MenuModel(title: "Cache in disk", detail: "", url: "CacheViewController", params: ["title": "Cache in disk", "type": "disk"], callback: nil),
                        MenuModel(title: "Cache in UserDefaults", detail: "", url: "CacheViewController", params: ["title": "Cache in UserDefaults", "type": "userDefaults"], callback: nil),
                        MenuModel(title: "Cache in Keychain", detail: "", url: "CacheViewController", params: ["title": "Cache in Keychain", "type": "keychain"], callback: nil)
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
        case .coreML:
            return Promise { sink in
                var list = [MenuModel]()
                if #available(iOS 11.0, *) {
                    list.append(MenuModel(title: "Detect from image", detail: "Detecting object in still images", url: "DetectFromImageViewController", params: ["title": "Detect from image"], callback: nil))
                }
                if #available(iOS 12.0, *) {
                    list.append(MenuModel(title: "Recognize from camera", detail: "Recognizing objects in live capture", url: "RecognizFromCameraViewController", params: ["title": "Recognize from camera"], callback: nil))
                }
                sink.fulfill(list)
            }
        default:
            return Promise(error: APError(statusCode: APStatusCode.badRequest.rawValue, message: "MenuType Error"))
        }
    }
}

enum MenuType: String {
    case none, uiComponent, data,
    listView, webView,
    cache, crash, coreML
}
struct MenuModel {
    var title: String
    var detail: String
    var url: String
    var params: [String: Any]
    var callback: (() -> Void)?
}
