//
//  LocationViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit
import CoreLocation
import SwiftLocation

class LocationViewController: BaseListViewController {
    
    struct InnerConst {
        static let CellIdentifier = "LocationTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _viewModel = LocationViewModel()
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
    
    override func setupBinding() {
        super.setupBinding()
        _viewModel.continuesLocation.producer.startWithValues {[weak self] location in
            if (self?._viewModel.dataArray.count ?? 0) > 0 {
                _ = self?._viewModel.fetchData().done { _ in 
                    self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
                }
            }
        }
    }
    
    override func loadData() {
        super.loadData()
        fetchData()
        _ = _viewModel.fetchGPSLocation().done { [weak self] _ in
            self?.fetchData()
            _ = self?._viewModel.fetchAddress().done { [weak self] _ in
                self?.fetchData()
            }
        }.catch({ error in
            print(error)
        })
        _ = _viewModel.fetchIPLocation().done { [weak self] _ in
            self?.fetchData()
        }
        _viewModel.fetchContinuesLocation()
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: InnerConst.CellIdentifier)
        }
        return cell
    }
    override func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? LocationModel {
            cell.textLabel?.text = model.title
            if let location = model.detail as? CLLocation {
                cell.detailTextLabel?.text = "(\(location.coordinate.latitude), \(location.coordinate.longitude))"
                return
            } else if let place = model.detail as? IPPlace {
                cell.detailTextLabel?.text = "(\(place.coordinates?.latitude ?? 0.0), \(place.coordinates?.longitude ?? 0.0))"
                return
            }
            cell.detailTextLabel?.text = "\(model.detail ?? "")"
        }
    }
    override func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let model = object as? LocationModel, let tip = model.detail as? String {
            (indicator as? APIndicator)?.showTip(inView: view, text: nil, detailText: tip, animated: true, hideAfter: 2, completion: {})
        }
    }

}
