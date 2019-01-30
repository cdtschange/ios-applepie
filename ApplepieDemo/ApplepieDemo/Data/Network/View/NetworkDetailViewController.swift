//
//  NetworkDetailViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import Applepie
import CocoaLumberjack

class NetworkDetailViewController: UITableViewController {
    enum Sections: Int {
        case headers, body
    }
    
    var viewModel = NetworkViewModel()
    
    var headers: [String: String] = [:]
    var body: String?
    var elapsedTime: TimeInterval?
    var segueIdentifier: String?
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = segueIdentifier
        
        switch segueIdentifier {
        case "GET":
            title = "Get"
        case "POST":
            title = "Post"
        case "PUT":
            title = "Put"
        case "DELETE":
            title = "Delete"
        case "UPLOAD":
            title = "Upload"
        case "UPLOADMULTIPART":
            title = "Multipart Upload"
        default:
            return
        }
        refresh()
    }
    
    deinit {
        DDLogInfo("Deinit NetworkDetailViewController")
    }
    
    // MARK: IBActions
    
    @IBAction func refresh() {
        
        refreshControl?.beginRefreshing()
        
        let start = CACurrentMediaTime()
        var method: NetworkType = .get
        switch segueIdentifier {
        case "GET":
            method = .get
        case "POST":
            method = .post
        case "PUT":
            method = .put
        case "DELETE":
            method = .delete
        case "UPLOAD":
            method = .upload
        case "UPLOADMULTIPART":
            method = .multipartUpload
        default:
            return
        }
        _ = viewModel.fetchData(method).done { result in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start
            
            if let headers = result?["headers"] as? [String: Any] {
                for (field, value) in headers {
                    self.headers["\(field)"] = "\(value)"
                }
            }
            
            if let segueIdentifier = self.segueIdentifier {
                switch segueIdentifier {
                case "GET", "POST", "PUT", "DELETE", "UPLOAD", "UPLOADMULTIPART":
                    var result = result
                    if let data = result?["data"] as? String, data.count > 200 {
                        result?["data"] = String(data[..<data.index(data.startIndex, offsetBy: 200)]) + "..."
                    }
                    if var files = result?["files"] as? [String: Any],
                        let name = files["name"] as? String, name.count > 100 {
                        files["name"] = String(name[..<name.index(name.startIndex, offsetBy: 100)]) + "..."
                        result?["files"] = files
                    }
                    self.body = "\(String(describing: result ?? [:]))"
                default:
                    break
                }
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    private func downloadedBodyString() -> String {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: cachesDirectory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            if let fileURL = contents.first, let data = try? Data(contentsOf: fileURL) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                if let prettyString = String(data: prettyData, encoding: String.Encoding.utf8) {
                    try fileManager.removeItem(at: fileURL)
                    return prettyString
                }
            }
        } catch {
            // No-op
        }
        
        return ""
    }
}

// MARK: - UITableViewDataSource

extension NetworkDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .headers:
            return headers.count
        case .body:
            return body == nil ? 0 : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: (indexPath as NSIndexPath).section)! {
        case .headers:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header")!
            let field = headers.keys.sorted(by: <)[indexPath.row]
            let value = headers[field]
            
            cell.textLabel?.text = field
            cell.detailTextLabel?.text = value
            
            return cell
        case .body:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Body")!
            cell.textLabel?.text = body
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension NetworkDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return ""
        }
        
        switch Sections(rawValue: section)! {
        case .headers:
            return "Headers"
        case .body:
            return "Body"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Sections(rawValue: (indexPath as NSIndexPath).section)! {
        case .body:
            return 300
        default:
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if Sections(rawValue: section) == .body, let elapsedTime = elapsedTime {
            let elapsedTimeText = NetworkDetailViewController.numberFormatter.string(from: elapsedTime as NSNumber) ?? "???"
            return "Elapsed Time: \(elapsedTimeText) sec"
        }
        
        return ""
    }

}
