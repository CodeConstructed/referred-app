//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommunityScreenViewDelegate: CommunityTableHeaderViewDelegate {
    func communityViewDidReadMoreTapped(
        _ communityView: CommunityScreenViewController.View,
        toVc: UIViewController
    )
    func communityViewDidPickerTapped(_ communityView: CommunityScreenViewController.View, toVc: UIViewController)
    func communityView(_ view: CommunityScreenViewController.View, didPickedNewSort type: LMModels.Others.SortType)
}

extension CommunityScreenViewController {
    
    class View: UIView {
        
        struct HeaderViewData {
            let communityView: LMModels.Views.CommunityView
        }
        
        struct TableViewData {
            let posts: [LMModels.Views.PostView]
        }
        
        weak var delegate: CommunityScreenViewDelegate?
        
        open var contentType: LMModels.Others.SortType = .active
        
        weak var tableManager: CommunityScreenTableDataSource?
                
        private lazy var tableView = LemmyTableView(style: .plain).then {
            $0.delegate = tableManager
            $0.registerClass(PostContentPreviewTableCell.self)
        }
        
        private lazy var emptyStateLabel = UILabel().then {
            $0.text = "nodata-posts".localized
            $0.textAlignment = .center
            $0.textColor = .tertiaryLabel
        }
        
        var communityHeaderViewData: LMModels.Views.CommunityView? {
            didSet {
                let view = CommunityTableHeaderView()
                view.delegate = delegate
                
                view.communityHeaderView.descriptionReadMoreButton
                    .addTarget(self, action: #selector(descriptionMoreButtonTapped), for: .touchUpInside)
                
                view.contentTypeView.addTap {
                    let vc = view.contentTypeView.configuredAlert
                    self.delegate?.communityViewDidPickerTapped(self, toVc: vc)
                }

                view.contentTypeView.newCasePicked = { newCase in
                    self.contentType = newCase
                    self.delegate?.communityView(self, didPickedNewSort: newCase)
                }
                
                view.bindData(community: communityHeaderViewData.require())
                tableView.tableHeaderView = view
                tableView.layoutTableHeaderView()
            }
        }
        
        init(tableManager: CommunityScreenTableDataSource) {
            self.tableManager = tableManager
            super.init(frame: .zero)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func showLoadingIndicator() {
            tableView.showActivityIndicator()
        }
        
        func hideLoadingIndicator() {
            tableView.hideActivityIndicator()
        }
        
        func updateTableViewData(dataSource: UITableViewDataSource) {
            self.hideLoadingIndicator()
            self.emptyStateLabel.isHidden = true
            _ = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
            //            self.emptyStateLabel.isHidden = numberOfRows != 0
            
            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
        }
        
        func appendNew(data: [LMModels.Views.PostView]) {
            self.tableManager?.appendNew(posts: data) { (newIndexpaths) in
                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexpaths, with: .none)
                }
            }
        }
        
        func deleteAllContent() {
            self.tableManager?.viewModels = []
            self.tableView.reloadData()
        }
        
        func displayNoData() {
            self.emptyStateLabel.isHidden = false
            self.hideLoadingIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.tableView.layoutTableHeaderView()
        }
        
        @objc func descriptionMoreButtonTapped(_ sender: UIButton) {
            if let desc = self.communityHeaderViewData.require().community.description {
                
                let vc = MarkdownParsedViewController(mdString: desc)
                let nc = StyledNavigationController(rootViewController: vc)
                self.delegate?.communityViewDidReadMoreTapped(self, toVc: nc)
            }
        }
    }
}

extension CommunityScreenViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        self.emptyStateLabel.isHidden = true
    }
    
    func addSubviews() {
        self.addSubview(tableView)
        self.addSubview(emptyStateLabel)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(350)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
