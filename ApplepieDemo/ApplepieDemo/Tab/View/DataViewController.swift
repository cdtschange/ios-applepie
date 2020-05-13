//
//  DataViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class DataViewController: BaseListViewController {

    struct InnerConst {
        static let CellIdentifier = "DataTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var _viewModel = MenuListViewModel()
    override var viewModel: APBaseViewModel? {
        return _viewModel
    }
    override var listView: UIScrollView! {
        return tableView
    }
    override var listViewType: ListViewType {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.tableFooterView = UIView()
    }
    
    override func setupBinding() {
        super.setupBinding()
        _viewModel.type = .data
    }
    
    override func loadData() {
        super.loadData()
        fetchData()
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
    }
    override func fillCell(with tableView: UITableView, cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? MenuModel {
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.detail
        }
    }
    override func didSelectCell(with tableView: UITableView, with object: Any, at indexPath: IndexPath) {
        if let model = object as? MenuModel {
            if model.url.hasPrefix("http") == true {
                APRouter.route(toUrl: model.url, params: model.params + APRouter.paramsForTabBarRoute)
                return
            } else {
                if model.url.contains(".") {
                    APRouter.route(toName: String(model.url.split(separator: ".").last!), params: model.params + APRouter.paramsForTabBarRoute, storyboardName: String(model.url.split(separator: ".").first!))
                    return
                }
                APRouter.route(toName: model.url, params: model.params + APRouter.paramsForTabBarRoute)
                return
            }
        }
    }
}
