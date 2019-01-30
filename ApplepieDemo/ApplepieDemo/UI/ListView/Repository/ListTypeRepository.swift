//
//  ListTypeRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit

class ListTypeRepository: BaseRepository {
    func fetchData(index: Int, size: Int) -> Promise<[String]> {
        return Promise { sink in
            sink.fulfill()
            }.then {
                return after(.seconds(1))
            }.map { _ in
                if index == 0 {
                    let start = index + 1
                    return (start...size).map { "This is \($0) item." }
                } else {
                    let start = index + 1
                    let count = start + size / 2
                    return (start...count).map { "This is \($0) item." }
                }
        }
    }
}


