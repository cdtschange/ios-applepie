//
//  IndicatorViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class IndicatorViewController: BaseListViewController {

    struct InnerConst {
        static let CellIdentifier = "IndicatorTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _viewModel = IndicatorViewModel()
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
    }
    
    override func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: InnerConst.CellIdentifier)
        }
        return cell
    }
    override func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        if let text = object as? String {
            cell.textLabel?.text = text
        }
    }
    override func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.showIndicator()
            after(.seconds(1)).done { [weak self] in
                self?.hideIndicator()
            }
        case 1:
            indicator?.show(inView: view, text: "Loading...", detailText: nil, animated: true)
            after(.seconds(1)).done { [weak self] in
                self?.hideIndicator()
            }
        case 2:
            indicator?.show(inView: view, text: "Loading...", detailText: "Parsing data\n(1/1)", animated: true)
            after(.seconds(1)).done { [weak self] in
                self?.hideIndicator()
            }
        case 3:
            (indicator as? APIndicator)?.showProgress(inView: view, text: "Loading...", detailText: "Parsing data\n(0/100)", cancelable: false, cancelTitle: nil, cancelHandler: nil, type: .determinate, animated: true)
            let timer = APRepeatingTimer(timeInterval: 0.01)
            var progress = 0
            timer.eventHandler = { [weak self] in
                progress += 1
                if progress > 100 {
                    self?.hideIndicator()
                    timer.suspend()
                    return
                }
                (self?.indicator as? APIndicator)?.changeProgress(inView: self?.view, text: nil, detailText: "Parsing data\n(\(progress)/100)", progress: progress.ap.toDouble / 100.0, animated: true)
            }
            timer.resume()
        case 4:
            (indicator as? APIndicator)?.showProgress(inView: view, text: "Loading...", detailText: "Parsing data\n(0/100)", cancelable: false, cancelTitle: nil, cancelHandler: nil, type: .annularDeterminate, animated: true)
            let timer = APRepeatingTimer(timeInterval: 0.01)
            var progress = 0
            timer.eventHandler = { [weak self] in
                progress += 1
                if progress > 100 {
                    self?.hideIndicator()
                    timer.cancel()
                    return
                }
                (self?.indicator as? APIndicator)?.changeProgress(inView: self?.view, text: nil, detailText: "Parsing data\n(\(progress)/100)", progress: progress.ap.toDouble / 100.0, animated: true)
            }
            timer.resume()
        case 5:
            (indicator as? APIndicator)?.showProgress(inView: view, text: "Loading...", detailText: "Parsing data\n(0/100)", cancelable: false, cancelTitle: nil, cancelHandler: nil, type: .determinateHorizontalBar, animated: true)
            let timer = APRepeatingTimer(timeInterval: 0.01)
            var progress = 0
            timer.eventHandler = { [weak self] in
                progress += 1
                if progress > 100 {
                    self?.hideIndicator()
                    timer.cancel()
                    return
                }
                (self?.indicator as? APIndicator)?.changeProgress(inView: self?.view, text: nil, detailText: "Parsing data\n(\(progress)/100)", progress: progress.ap.toDouble / 100.0, animated: true)
            }
            timer.resume()
        case 6:
            var timer: APRepeatingTimer? = APRepeatingTimer(timeInterval: 0.1)
            let cancelHandler = {
                timer?.cancel()
                timer = nil
            }
            (indicator as? APIndicator)?.showProgress(inView: view, text: "Loading...", detailText: "Parsing data\n(0/100)", cancelable: true, cancelTitle: "Cancel", cancelHandler: cancelHandler, type: .annularDeterminate, animated: true)
            var progress = 0
            timer?.eventHandler = { [weak self] in
                progress += 1
                if progress > 100 {
                    self?.hideIndicator()
                    return
                }
                (self?.indicator as? APIndicator)?.changeProgress(inView: self?.view, text: nil, detailText: "Parsing data\n(\(progress)/100)", progress: progress.ap.toDouble / 100.0, animated: true)
            }
            timer?.resume()
        case 7:
            self.showTip("This is a message")
        case 8:
            (indicator as? APIndicator)?.showTip(inView: view, text: "This is a bottom message", detailText: nil, image: nil, offset: CGPoint(x: 0, y: Int.max), animated: true, hideAfter: 2)
        case 9:
            (indicator as? APIndicator)?.showTip(inView: view, text: "This is a custom message", detailText: nil, image: UIImage(named: "icon_indicator_checkmark"), offset: nil, animated: true, hideAfter: 2)
        default:
            break
        }
    }
}
