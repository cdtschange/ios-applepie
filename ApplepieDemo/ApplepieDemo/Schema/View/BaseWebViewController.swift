//
//  BaseWebViewController.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/3.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class BaseWebViewController: APBaseWebViewController {

    var _indicator = APIndicator()
    open override var indicator: APIndicatorProtocol? {
        return _indicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
