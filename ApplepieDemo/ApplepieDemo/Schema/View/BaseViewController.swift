//
//  BaseViewController.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2018/12/30.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import UIKit
import Applepie

open class BaseViewController: APBaseViewController {
    
    var _indicator = APIndicator()
    open override var indicator: APIndicatorProtocol? {
        return _indicator
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(NSStringFromClass(self.classForCoder))
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(NSStringFromClass(self.classForCoder))
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
