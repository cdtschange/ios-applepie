//
//  CacheViewController.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class CacheViewController: BaseListViewController {
    
    struct InnerConst {
        static let CellIdentifier = "CacheTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc
    var type: String = CacheType.disk.rawValue
    
    private var _viewModel = CacheViewModel()
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

    override func loadData() {
        super.loadData()
        _viewModel.type = CacheType(rawValue: type)!
        fetchData()
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: InnerConst.CellIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        return cell
    }
    override func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? CacheModel {
            cell.textLabel?.text = model.title
            var value = "\(model.detail ?? "")"
            if let detail = model.detail as? Double {
                value = String(format: "%.1f", detail)
            }
            cell.detailTextLabel?.text = value
        }
    }
    override func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? CacheModel {
            let type = CacheType(rawValue: self.type)!
            switch model.title {
            case "String": _viewModel.saveString(type)
            case "Int": _viewModel.saveInt(type)
            case "Double": _viewModel.saveDouble(type)
            case "Bool": _viewModel.saveBool(type)
            default:
                break
            }
            _viewModel.dataArray[indexPath.row] = _viewModel.updateData(type, key: model.title)!
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }

}
