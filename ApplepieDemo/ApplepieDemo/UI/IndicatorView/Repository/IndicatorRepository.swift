//
//  IndicatorRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit

class IndicatorRepository: BaseRepository {
    
    func fetchData() -> Promise<[String]> {
        return Promise { sink in
            sink.fulfill([
                "Indeterminate mode",
                "With label",
                "With details label",
                "Determinate mode",
                "Annular determinate mode",
                "Bar determinate mode",
                "Determinate mode with cancel",
                "Tip",
                "Tip at bottom",
                "Custom view with image"
                ])
        }
    }
}
