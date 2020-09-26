//
//  FrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

class FrontPageViewController: UIViewController {
    
    let model = FrontPageModel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let searchBarView = LemmySearchBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        setupTableView()
        setupNavigationItem()
        
        model.loadPosts()
        model.dataLoaded = {
            self.tableView.reloadData()            
        }
    }
    
    private func setupTableView() {
        tableView.delegate = model
        tableView.dataSource = model
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationItem() {
        navigationItem.titleView = searchBarView
        self.searchBarView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(60)
        }
        navigationItem.titleView?.frame.size.width = UIScreen.main.bounds.width
    }
}
