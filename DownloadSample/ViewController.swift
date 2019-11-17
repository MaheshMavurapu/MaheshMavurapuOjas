//
//  ViewController.swift
//  DownloadSample
//
//  Created by ojas on 17/11/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import UIKit

// MainView
class ViewController: UIViewController {

    // Properties
    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    var allPoints: Int16 = 0
    let viewModel: ViewModel = ViewModel()
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel.getViewController(self) // View Model - Rerference.
    }
    
    @IBAction func refreshTapped(_ button: UIButton) {
        self.viewModel.refreshTheTable()
    }
}

// Protocol - For slection of points.
protocol SelectedPoints {
    func selectedPoints(_ points: Int16, _ status: Bool)
}

// TableView Cell - View
class TableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var checkUncheckButton: UIButton!
    
    var status: Bool!
    var point: Int16!
    var selectedPointDelegate: SelectedPoints?
    
    @IBAction func tapped(_ button: UIButton) {
        if status {
            self.checkUncheckButton.setImage(UIImage(named: "Unchecked"), for: .normal)
            selectedPointDelegate?.selectedPoints(self.point, false)
            self.status = false
        } else {
            self.checkUncheckButton.setImage(UIImage(named: "Checked"), for: .normal)
            selectedPointDelegate?.selectedPoints(self.point, true)
            self.status = true
        }
    }
}
