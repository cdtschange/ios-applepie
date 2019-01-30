//
//  DeviceInfoViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class DeviceInfoViewController: BaseListViewController {

    struct InnerConst {
        static let CellIdentifier = "DeviceInfoTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _viewModel = DeviceInfoViewModel()
    override var viewModel: APBaseViewModel? {
        return _viewModel
    }
    override var listViewType: ListViewType {
        return .none
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
        fetchData()
        _ = _viewModel.fetchNetwork().done { [weak self] _ in
            self?.fetchData()
        }
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: InnerConst.CellIdentifier)
        }
        return cell
    }
    override func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? DeviceInfoModel {
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(model.detail ?? "")"
        }
    }
    override func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? DeviceInfoModel, let tip = model.detail as? String {
            (indicator as? APIndicator)?.showTip(inView: view, text: nil, detailText: tip, animated: true, hideAfter: 2, completion: {})
        }
    }

}
