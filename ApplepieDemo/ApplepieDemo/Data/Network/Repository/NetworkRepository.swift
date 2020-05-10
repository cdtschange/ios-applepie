//
//  NetworkRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit
import Applepie

class NetworkRepository: BaseRepository {
    
    func fetchData(_ method: NetworkType) -> Promise<NetworkApi> {
        switch method {
        case .get:
            return GetNetworkApi().promise().map { $0 as NetworkApi }
        case .post:
            return PostNetworkApi().promise().map { $0 as NetworkApi }
        case .put:
            return PutNetworkApi().promise().map { $0 as NetworkApi }
        case .delete:
            return DeleteNetworkApi().promise().map { $0 as NetworkApi }
        case .upload:
            let api = UploadNetworkApi()
            api.dataUrl = Bundle.main.url(forResource: "rainbow", withExtension: "jpg")
            return api.promise().map  { $0 as NetworkApi }
        case .multipartUpload:
            let api = MultipartUploadNetworkApi()
            let imageURL = Bundle.main.url(forResource: "rainbow", withExtension: "jpg")
            let fileData = try! Data(contentsOf: imageURL!)
            let file = APUploadMultipartFile(data: fileData, name: "name", fileName: "fileName" , mimeType: "image/jpeg")
            api.files = [file]
            return api.promise().map  { $0 as NetworkApi }
        }
    }
}

enum NetworkType {
    case get, post, put, delete, upload, multipartUpload
}
