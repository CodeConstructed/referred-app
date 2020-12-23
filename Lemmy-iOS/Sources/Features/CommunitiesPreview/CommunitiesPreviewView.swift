//
//  CommunitiesPreviewView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunitiesPreviewViewDelagate: AnyObject {
    func previewViewDidRequestRefresh()
}

class CommunitiesPreviewView: UIView {
        
    weak var delegate: CommunitiesPreviewViewDelagate?
    
    private lazy var tableView = LemmyTableView(style: .plain, separator: false).then {
        $0.registerClass(CommunityPreviewTableCell.self)
        $0.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged), for: .valueChanged)
    }
    
    private let refreshControl = UIRefreshControl()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToTop() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func showLoadingView() {
        tableView.showActivityIndicator()
    }
    
    func hideLoadingView() {
        tableView.hideActivityIndicator()
    }
    
    func updateTableViewData(dataSource: (UITableViewDataSource & UITableViewDelegate)) {
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        //            self.emptyStateLabel.isHidden = numberOfRows != 0
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
    
    @objc func refreshControlValueChanged() {
        self.delegate?.previewViewDidRequestRefresh()
    }
}

extension CommunitiesPreviewView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
