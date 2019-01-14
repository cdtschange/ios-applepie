//
//  APBaseListViewController.swift
//  Zijingcaizhi
//
//  Created by 毛蔚 on 2018/12/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import UIKit
import MJRefresh
import CocoaLumberjack
import PromiseKit

public enum ListViewType {
    case none
    case refreshOnly
    case loadMoreOnly
    case both
}

open class APBaseListViewController:
    APBaseViewController,
    UITableViewDelegate,
    UITableViewDataSource {
    
    fileprivate struct InnerConstant {
        static let noMoreDataTip = "数据已全部加载完毕"
    }
    
    open var listViewModel: APBaseListViewModel! {
        get {
            return viewModel as? APBaseListViewModel
        }
    }
    open var listView: UIScrollView! {
        get {
            return nil
        }
    }
    open var listViewType: ListViewType {
        get {
            return .refreshOnly
        }
    }
    
    open func autoFetchListData() {
        after(.milliseconds(400)).done { [weak self] in
            self?.listView.mj_header?.beginRefreshing()
        }
    }
    
    open func willFetchListData() {
    }
    open func didFetchListData(_ data: Any) {
        guard let data = data as? [Any] else { return }
        endListRefresh()
        if listViewType == .refreshOnly ||
            listViewType == .none {
            reloadListView()
            return
        }
        var noMoreDataTip = InnerConstant.noMoreDataTip
        let count = data.count
        if count == 0 {
            listView.mj_footer?.endRefreshingWithNoMoreData()
            reloadListView()
            return
        }
        listView.mj_footer.resetNoMoreData()
        
        if UInt(count) % listViewModel.listLoadNumber > 0 ||
            count >= listViewModel.listMaxNumber {
            listView.mj_footer.endRefreshingWithNoMoreData()
            
            if count < listViewModel.listLoadNumber {
                listView.mj_footer.endRefreshingWithNoMoreData()
                noMoreDataTip = ""
            }
        }
        if let footer = listView.mj_footer as? MJRefreshAutoStateFooter {
            footer.setTitle(noMoreDataTip, for: .noMoreData)
        }
        reloadListView()
    }
    open func didFetchListDataFailed(error: Error) {
        showTip(error)
    }
    
    open func fetchData() {
        willFetchListData()
        listViewModel.fetchData().map { [weak self] data -> (Any) in
            self?.didFetchListData(data)
            return data
            }.catch { [weak self] error in
                self?.didFetchListDataFailed(error: error)
        }
    }
    
    open override func setupUI() {
        super.setupUI()
        if self.listViewType == .none || self.listViewType == .loadMoreOnly {
            self.listView.mj_header = nil
        } else {
            self.listView.mj_header = self.listViewHeaderWithRefreshingBlock {
                [weak self] in
                self?.listViewModel.dataIndex = 0
                self?.fetchData()
            }
        }
        if self.listViewType == .none || self.listViewType == .refreshOnly {
            self.listView.mj_footer = nil
        } else {
            self.listView.mj_footer = self.listViewFooterWithRefreshingBlock {
                [weak self] in
                self?.listViewModel?.dataIndex += 1
                self?.fetchData()
            }
            self.listView.mj_footer.endRefreshingWithNoMoreData()
            if let footer = self.listView.mj_footer as? MJRefreshAutoStateFooter {
                footer.setTitle("", for: .noMoreData)
            }
        }
        //声明tableView的位置 添加下面代码
        if #available(iOS 11.0, *) {
            self.listView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    open func listViewHeaderWithRefreshingBlock(_ refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock:refreshingBlock);
        header?.activityIndicatorViewStyle = .gray
        header?.labelLeftInset = 0
        header?.setTitle("", for: .idle)
        header?.setTitle("", for: .pulling)
        header?.setTitle("", for: .refreshing)
        header?.lastUpdatedTimeLabel.text = ""
        header?.lastUpdatedTimeText = { _ in return "" }
        return header!
    }
    open func listViewFooterWithRefreshingBlock(_ refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) -> MJRefreshFooter {
        let footer = MJRefreshAutoStateFooter(refreshingBlock:refreshingBlock);
        return footer!
    }
    
    open func getCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        DDLogError("Need to implement the function of 'getCellWithTableView'")
        return nil
    }
    open func fillCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
        DDLogError("Need to implement the function of 'configureCell'")
    }
    open func didSelectCell(_ cell: UITableViewCell, with object: Any, at indexPath: IndexPath) {
    }
    open func object(at indexPath: IndexPath) -> Any? {
        let object = listViewModel.dataArray[indexPath.row]
        return object
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.dataArray.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(with: tableView, at: indexPath)!
        if let object = object(at: indexPath) {
            fillCell(cell, with: object, at: indexPath)
        }
        return cell
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = getCell(with: tableView, at: indexPath)!
        if let object = object(at: indexPath) {
            didSelectCell(cell, with: object, at: indexPath)
        }
    }
    
    open func reloadListView() {
        switch self.listView {
        case let tableView as UITableView:
            tableView.reloadData()
        case let collectionView as UICollectionView:
            collectionView.reloadData()
        default:
            return
        }
    }
    
    open func endListRefresh() {
        if self.listViewModel.dataIndex == 0 {
            self.listView?.mj_header?.endRefreshing()
        } else {
            if self.listView?.mj_footer.state == .refreshing {
                self.listView?.mj_footer.endRefreshing()
            }
        }
    }
    
    deinit {
    }
}
