//
//  UIColor+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import UIKit

public extension Applepie where Base == UIColor {
    
    public var toImage: UIImage? {
        //创建1像素区域并开始绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(base.cgColor)
        context?.fill(rect)
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
