//
//  APValidator.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/9.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit

public class APValidator: NSObject {

    public class func validate(conditions: [(condition: Bool, message: String)]) -> Promise<Void> {
        return validate(conditions: conditions.map { ($0, APStatusCode.validateFailed.rawValue, $1) })
    }
    public class func validate(conditions: [(condition: Bool, code: Int, message: String)]) -> Promise<Void> {
        for condition in conditions {
            if condition.0 {
                let error = APError(statusCode: condition.1, message: condition.2)
                return Promise(error: error)
            }
        }
        return Promise { sink in
            sink.fulfill(())
        }
    }
}
