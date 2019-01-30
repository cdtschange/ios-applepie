//
//  NetworkViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import CocoaLumberjack

class NetworkViewController: UITableViewController, APRouterProtocol {
    
    open var params = [String: Any]() {
        didSet {
            self.setValuesForKeys(params)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? NetworkDetailViewController {
            detailViewController.segueIdentifier = segue.identifier
        }
    }
    
    deinit {
        DDLogInfo("Deinit NetworkViewController")
    }
}
