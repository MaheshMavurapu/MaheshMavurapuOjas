//
//  ViewModel.swift
//  DownloadSample
//
//  Created by ojas on 17/11/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import Foundation
import UIKit

public class ViewModel: NSObject {
    // Properties
    var viewController: ViewController!
    var posts: [Post] = []
    var allPoints: Int16 = 0
    
    // Methods
    func getViewController(_ controller: ViewController) {
        self.viewController = controller
        self.parseJsonForNumberOfHits()
    }
}

public extension ViewModel {
    func initialSetUp() {
        self.viewController.tableView.delegate = self
        self.viewController.tableView.dataSource = self
        self.viewController.tableView.reloadData()
    }
    
    // Parse Json - Results
    func parseJsonForNumberOfHits() {
        JsonParse.parse.parse(completion:  { [weak self] (res) in
            switch res {
            case .success(let result):
                DispatchQueue.main.async {
                    if result {
                        self?.posts = CoreDataManager.sharedManager.fetchObjects()
                    } else {
                        self?.posts = []
                    }
                    self?.initialSetUp()
                }
            case .failure(let error):
                print(error)
            }
        })// Parse - Done
    }
    
    // Refresh the table aka Posts
    func refreshTheTable() {
        CoreDataManager.sharedManager.clearAll("Post")
        self.parseJsonForNumberOfHits()
    }
}

extension ViewModel: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let post = self.posts[indexPath.row]
        tableViewCell.name.text = post.title
        tableViewCell.createdTime.text = post.createdAt
        tableViewCell.status = false
        tableViewCell.point = post.points
        tableViewCell.checkUncheckButton.setImage(UIImage(named: "Unchecked"), for: .normal)
        
        tableViewCell.selectedPointDelegate = self
        
        return tableViewCell
    }
}

//
extension ViewModel: SelectedPoints {
    func selectedPoints(_ points: Int16, _ status: Bool) {
        if status {
            self.allPoints = self.allPoints + points
        } else {
            self.allPoints = self.allPoints - points
        }
        let customTitle = self.viewController.navigationController?.visibleViewController?.navigationItem
        customTitle?.title = "Points - \(self.allPoints)"
    }
}

