//
//  PropertyReflector.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/2.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

/// Swift 反射工具类：运用 KVC 动态地给类的成员变量赋值
class SwiftReflectionTool: NSObject {
    // MARK: - 私有成员变量
    fileprivate static let valueTypesMap: Dictionary<String, Any> =
        [ "c" : Int8.self,
          "s" : Int16.self,
          "i" : Int32.self,
          "q" : Int.self,
          "S" : UInt16.self,
          "I" : UInt32.self,
          "Q" : UInt.self,
          "B" : Bool.self,
          "d" : Double.self,
          "f" : Float.self,
          "{" : Decimal.self
    ]
    fileprivate struct InnerConst {
        static let INT8 = "int8"
        static let INT16 = "int16"
        static let INT32 = "int32"
        static let INT = "int"
        static let FLOAT = "float"
        static let DOUBLE = "double"
        static let BOOL = "bool"
        static let STRING = "string"
        static let DATE = "date"
        static let NULL = "null"
    }
    // MARK: - 公开方法
    // MARK: 获取对象属性类型列表
    /// 获取对象属性类型列表
    /// - 注意：这种方式获取属性，对于非引用类型的属性，必须有初始值，否则无法获取到！
    ///
    /// - parameter clazz:         对象类型
    ///
    /// - returns: 属性名 & 类型 字典数组.
    open class func propertyList(clazz: NSObject.Type) -> [[String: Any]]? {
        var count: UInt32 = 0
        let list = class_copyPropertyList(clazz, &count)
        var resultList = [[String: Any]]()
        for i in 0..<Int(count) {
            guard let pty = list?[i],
                let cName = getNameOf(property: pty),
                let name = String(utf8String: cName)
                else {
                    continue
            }
            let type = getTypeOf(property: pty)
            resultList.append([name: type])
        }
        free(list)
        return resultList
    }
    /// 获取对象属性类型列表
    /// - 注意：这种方式获取属性，对于非引用类型的属性，必须有初始值，否则无法获取到！
    ///
    /// - parameter obj:         对象实例(instance) 或者 类类型(Class.self)
    ///
    /// - returns: 属性名 & 类型 字典数组.
    open class func propertyList(obj: Any) -> [[String: Any]]? {
        var clazz = type(of: obj)
        if obj is Any.Type {
            clazz = obj as! Any.Type
        }
        if let clazz = clazz as? NSObject.Type {
            return propertyList(clazz: clazz)
        }
        return nil
    }
    // MARK: 给对象赋值
    /// 给对象赋值
    ///
    /// - parameter paramsDict:         参数字典
    /// - parameter obj:                待赋值的对象
    /// - parameter complete:           赋值完成的回调
    open class func setParams(_ paramsDict: [String: Any]?, for obj: NSObject, complete: (()->()) = {}) {
        if let paramsDict = paramsDict {
            let clazz: NSObject.Type = type(of: obj)
            let list = propertyList(clazz: clazz) ?? []
            var filteredList = [[String: Any]]()
            let _ = paramsDict.map({ dict in
                let tmp = list.filter({ $0.keys.contains(dict.key)}).first ?? [:]
                filteredList.append(tmp)
            })
            print("================= 赋值开始 =================")
            for (key, value) in paramsDict {
                // 取出key对应的类型
                let value = "\(value)"
                let type = getType(key: key, typeDictList: filteredList)
                if InnerConst.BOOL == type {
                    let toValue = value.ap.toBool ?? false
                    obj.setValue(toValue, forKey: key)
                } else if InnerConst.STRING == type {
                    obj.setValue(value, forKey: key)
                } else if InnerConst.INT == type {
                    let toValue = value.ap.toInt ?? 0
                    obj.setValue(toValue, forKey: key)
                } else if InnerConst.DOUBLE == type {
                    let toValue = value.ap.toDouble ?? 0
                    obj.setValue(toValue, forKey: key)
                } else if InnerConst.FLOAT == type {
                    let toValue = value.ap.toFloat ?? 0
                    obj.setValue(toValue, forKey: key)
                } else if InnerConst.DATE == type {
                    let toValue = Date(fromString: value, format: "yyyyMMdd")
                    obj.setValue(toValue, forKey: key)
                } else if InnerConst.NULL == type {
                    print("[\(obj)]没有[\(key)]参数")
                }
            }
            print("================= 赋值完成 =================")
            complete()
        }
    }
    // MARK: 字典中的vlaue转成能赋值的类型
    ///
    /// - parameter paramsDict:         参数字典
    /// - parameter obj:                待赋值的对象
    open class func transformParams(_ paramsDict:[String:Any]?, for obj: NSObject) -> [String:Any]? {
        var canSetDict:[String:Any]? = nil
        if let paramsDict = paramsDict {
            let clazz: NSObject.Type = type(of: obj)
            let list = propertyList(clazz: clazz) ?? []
            var filteredList = [[String: Any]]()
            let _ = paramsDict.map({ dict in
                let tmp = list.filter({ $0.keys.contains(dict.key)}).first ?? [:]
                filteredList.append(tmp)
            })
            canSetDict = [:]
            for (key, value) in paramsDict {
                // 取出key对应的类型
                let value = "\(value)"
                let type = getType(key: key, typeDictList: filteredList)
                if InnerConst.BOOL == type {
                    let toValue = value.ap.toBool ?? false
                    canSetDict?[key] = toValue
                } else if InnerConst.STRING == type {
                    canSetDict?[key] = value
                } else if InnerConst.INT == type {
                    let toValue = value.ap.toInt ?? 0
                    canSetDict?[key] = toValue
                } else if InnerConst.DOUBLE == type {
                    let toValue = value.ap.toDouble ?? 0
                    canSetDict?[key] = toValue
                } else if InnerConst.FLOAT == type {
                    let toValue = value.ap.toFloat ?? 0
                    canSetDict?[key] = toValue
                } else if InnerConst.DATE == type {
                    let toValue = Date(fromString: value, format: "yyyyMMdd")
                    canSetDict?[key] = toValue
                } else if InnerConst.NULL == type {
                    print("[\(obj)]没有[\(key)]参数")
                }
            }
        }
        return canSetDict
    }
    
    
    /// 字典 -> 元组
    open class func convert(dict: [String: Any]) -> (String, Any) {
        for (key, value) in dict {
            return (key, value)
        }
        return ("", NSNull())
    }
    // MARK: - 私有方法
    // MARK: 获取实例的成员变量列表
    fileprivate class func getNameOf(property: objc_property_t) -> String? {
        guard let name: NSString = NSString(utf8String: property_getName(property)) else { return nil }
        return name as String
    }
    fileprivate class func getTypeOf(property: objc_property_t) -> Any {
        guard let attributesAsNSString: NSString = NSString(utf8String: property_getAttributes(property)!) else { return Any.self }
        let attributes = attributesAsNSString as String
        let slices = attributes.components(separatedBy: "\"")
        guard slices.count > 1 else { return valueType(withAttributes: attributes) }
        let objectClassName = slices[1]
        let objectClass = NSClassFromString(objectClassName) as! NSObject.Type
        return objectClass
    }
    fileprivate class func valueType(withAttributes attributes: String) -> Any {
        guard let letter = attributes.substring(from: 1, to: 2), let type = valueTypesMap[letter] else { return Any.self }
        return type
    }
    // MARK: 获取属性类型
    private class func getType(key: String, typeDictList: [[String: Any]]) -> String {
        for dict in typeDictList {
            for (x, _) in dict {
                if x == key {
                    let (name, type) = convert(dict: dict)
                    print(name + " | \(type)")
                    let typeStr = "\(type)".lowercased()
                    if typeStr.contains(InnerConst.INT8) {
                        return InnerConst.INT8
                    } else if typeStr.contains(InnerConst.INT16) {
                        return InnerConst.INT16
                    } else if typeStr.contains(InnerConst.INT32) {
                        return InnerConst.INT32
                    } else if typeStr.contains(InnerConst.INT) {
                        return InnerConst.INT
                    } else if typeStr.contains(InnerConst.FLOAT) {
                        return InnerConst.FLOAT
                    } else if typeStr.contains(InnerConst.DOUBLE) {
                        return InnerConst.DOUBLE
                    } else if typeStr.contains(InnerConst.BOOL) {
                        return InnerConst.BOOL
                    } else if typeStr.contains(InnerConst.STRING) {
                        return InnerConst.STRING
                    } else if typeStr.contains(InnerConst.DATE) {
                        return InnerConst.DATE
                    }
                }
            }
        }
        return InnerConst.NULL
    }
}


private extension String {
    func substring(from fromIndex: Int, to toIndex: Int) -> String? {
        let substring = self[self.index(self.startIndex, offsetBy: fromIndex)..<self.index(self.startIndex, offsetBy: toIndex)]
        return String(substring)
    }
}
