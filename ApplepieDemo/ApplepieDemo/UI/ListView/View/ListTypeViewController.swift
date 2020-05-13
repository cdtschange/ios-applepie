//
//  ListViewNoneViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class ListTypeViewController: BaseListViewController {
    
    struct InnerConst {
        static let CellIdentifier = "ListTypeTableViewCell"
    }
    
    @objc
    var type: String = "none"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _viewModel = ListTypeViewModel()
    override var viewModel: APBaseViewModel? {
        return _viewModel
    }
    override var listViewType: ListViewType {
        return ListViewType(rawValue: type) ?? .none
    }
    override var listView: UIScrollView! {
        return tableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.tableFooterView = UIView()
    }
    
    override func loadData() {
        super.loadData()
        if listViewType == .none || listViewType == .loadMoreOnly {
            fetchData()
        } else {
            autoFetchListData()
        }
    }
    override func willFetchListData() {
        super.willFetchListData()
        if listViewType == .none || _viewModel.dataIndex == 0 &&  listViewType == .loadMoreOnly {
            showIndicator()
        }
    }
    override func didFetchListData(_ data: Any) {
        super.didFetchListData(data)
        if listViewType == .none || _viewModel.dataIndex == 0 &&  listViewType == .loadMoreOnly {
            hideIndicator()
        }
    }

    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: InnerConst.CellIdentifier)
        }
        return cell
    }
    override func fillCell(with tableView: UITableView, cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let text = object as? String {
            cell.textLabel?.text = text
        }
    }

}
