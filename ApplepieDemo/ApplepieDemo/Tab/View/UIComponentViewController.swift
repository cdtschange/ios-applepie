//
//  UIViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class UIComponentViewController: BaseListViewController {

    struct InnerConst {
        static let CellIdentifier = "UIComponentTableViewCell"
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
        _viewModel.type = .uiComponent
    }
    
    override func loadData() {
        super.loadData()
        fetchData()
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
    }
    override func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? MenuModel {
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.detail
        }
    }
    override func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? MenuModel {
            if model.url.hasPrefix("http") == true {
                APRouter.route(toUrl: model.url, params: model.params)
                return
            } else {
                APRouter.route(toName: model.url, params: model.params)
                return
            }
        }
    }
    

}
