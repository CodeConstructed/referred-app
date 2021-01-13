//
//  ProfileScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Pageboy

protocol ProfileScreenScrollablePageViewProtocol: AnyObject {
    var scrollViewDelegate: UIScrollViewDelegate? { get set }
    var contentInsets: UIEdgeInsets { get set }
    var contentOffset: CGPoint { get set }
    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior { get set }
}

protocol ProfileScreenViewControllerProtocol: AnyObject {
    func displayProfile(viewModel: ProfileScreenDataFlow.ProfileLoad.ViewModel)
    func displayNotBlockingActivityIndicator(viewModel: ProfileScreenDataFlow.ShowingActivityIndicator.ViewModel)
    func displayMoreButtonAlert(viewModel: ProfileScreenDataFlow.IdentifyProfile.ViewModel)
}

class ProfileScreenViewController: UIViewController {
    private static let topBarAlphaStatusBarThreshold = 0.85
    
    weak var coordinator: ProfileScreenCoordinator?
    
    private let viewModel: ProfileScreenViewModelProtocol

    private var availableTabs: [ProfileScreenDataFlow.Tab] = [.posts, .comments, .about]
    private lazy var pageViewController = PageboyViewController()
    
    // Due to lazy initializing we should know actual values to update inset/offset of new scrollview
    private var lastKnownScrollOffset: CGFloat = 0
    private var lastKnownHeaderHeight: CGFloat = 0
    
    // Element is nil when view controller was not initialized yet
    private var submodulesControllers: [UIViewController] = []
    private var submoduleInputs: [ProfileScreenSubmoduleProtocol] = []
    
    private lazy var profileScreenView = self.view as! ProfileScreenViewController.View
    lazy var styledNavigationController = self.navigationController as? StyledNavigationController
    
    private lazy var showMoreBarButton = UIBarButtonItem(
        image: Config.Image.ellipsis,
        style: .done,
        target: self,
        action: #selector(moreBarButtonTapped(_:))
    )
    
    private var storedViewModel: ProfileScreenHeaderView.ViewData?
    
    init(viewModel: ProfileScreenViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let statusBarHeight = UIApplication.shared.lemmyStatusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0

        let appearance = ProfileScreenViewController.View.Appearance(
            headerTopOffset: statusBarHeight + navigationBarHeight
        )

        let view = ProfileScreenViewController.View(
            frame: UIScreen.main.bounds,
            pageControllerView: pageViewController.view,
            scrollDelegate: self,
            tabsTitles: self.availableTabs.map { $0.title },
            appearance: appearance
        )
        view.delegate = self
        
        self.view = view
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSubmodules()
        
        self.addChild(self.pageViewController)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.profileScreenView.updateCurrentPageIndex(ProfileScreenDataFlow.Tab.posts.rawValue)
        
        styledNavigationController?.removeBackButtonTitleForTopController()
        navigationItem.rightBarButtonItem = showMoreBarButton
        
        viewModel.doProfileFetch()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        styledNavigationController?.insertBackButtonTitleForTopController()
//        coordinator?.removeDependency(coordinator)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.view.performBlockIfAppearanceChanged(from: previousTraitCollection) {
            // Update status bar style.
            self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
        }
    }
    
    @objc private func moreBarButtonTapped(_ action: UIBarButtonItem) {
        self.viewModel.doIdentifyProfile()
    }
    
    private func updateTopBar(alpha: CGFloat) {
        self.view.performBlockUsingViewTraitCollection {
            self.styledNavigationController?.changeBackgroundColor(
                StyledNavigationController.Appearance.backgroundColor.withAlphaComponent(alpha),
                sender: self
            )

//            let transitionColor = ColorTransitionHelper.makeTransitionColor(
//                from: .darkText,
//                to: .label,
//                transitionProgress: alpha
//            )
//            self.styledNavigationController?.changeTintColor(transitionColor, sender: self)
            self.styledNavigationController?.changeTextColor(
                StyledNavigationController.Appearance.tintColor.withAlphaComponent(alpha),
                sender: self
            )

//            let statusBarStyle: UIStatusBarStyle = {
//                if alpha > CGFloat(ProfileScreenViewController.topBarAlphaStatusBarThreshold) {
//                    return self.view.isDarkInterfaceStyle ? .lightContent : .dark
//                } else {
//                    return .lightContent
//                }
//            }()
//
//            self.styledNavigationController?.changeStatusBarStyle(statusBarStyle, sender: self)
        }
    }
    
    private func loadSubmodules() {
        
        guard let coordinator = coordinator else { return }
        
        availableTabs.forEach { (tab) in
            switch tab {
            case .posts:
                let assembly = ProfileScreenPostsAssembly(coordinator: WeakBox(coordinator))
                submodulesControllers.append(assembly.makeModule())
                submoduleInputs.append(assembly.moduleInput!)
            case .comments:
                let assembly = ProfileScreenCommentsAssembly(coordinator: WeakBox(coordinator))
                submodulesControllers.append(assembly.makeModule())
                submoduleInputs.append(assembly.moduleInput!)
            case .about:
                let assembly = ProfileScreenAboutAssembly()
                submodulesControllers.append(assembly.makeModule())
                submoduleInputs.append(assembly.moduleInput!)
            }
        }
        
        self.viewModel.doSubmodulesRegistration(request: .init(submodules: submoduleInputs))
    }
    
    // Update content inset (to make header visible)
    private func updateContentInset(headerHeight: CGFloat) {
        // Update contentInset for each page
        for viewController in self.submodulesControllers {
//            guard let viewController = viewController else {
//                continue
//            }

            let view = viewController.view as? ProfileScreenScrollablePageViewProtocol

            if let view = view {
                view.contentInsets = UIEdgeInsets(
                    top: headerHeight,
                    left: view.contentInsets.left,
                    bottom: view.contentInsets.bottom,
                    right: view.contentInsets.right
                )
                view.scrollViewDelegate = self
            }

            viewController.view.setNeedsLayout()
            viewController.view.layoutIfNeeded()

            view?.contentInsetAdjustmentBehavior = .never
        }
    }

    // Update content offset (to update appearance and offset on each tab)
    private func updateContentOffset(scrollOffset: CGFloat) {
        
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height
        let statusBarHeight = min(
            UIApplication.shared.lemmyStatusBarFrame.size.width,
            UIApplication.shared.lemmyStatusBarFrame.size.height
        )
        let topPadding = (navigationBarHeight ?? 0) + statusBarHeight

        let offsetWithHeader = scrollOffset
            + profileScreenView.headerHeight
            + profileScreenView.appearance.segmentedControlHeight
        let headerHeight = profileScreenView.headerHeight - topPadding

        let scrollingProgress = max(0, min(1, offsetWithHeader / headerHeight))
        self.updateTopBar(alpha: scrollingProgress)

        // Pin segmented control
        let scrollViewOffset = min(offsetWithHeader, headerHeight)
        profileScreenView.updateScroll(offset: scrollViewOffset)

        // Arrange page views contentOffset
        let offsetWithHiddenHeader = -(topPadding + profileScreenView.appearance.segmentedControlHeight)
        self.arrangePagesScrollOffset(
            topOffsetOfCurrentTab: scrollOffset,
            maxTopOffset: offsetWithHiddenHeader
        )
    }
    
    private func arrangePagesScrollOffset(topOffsetOfCurrentTab: CGFloat, maxTopOffset: CGFloat) {
        for viewController in self.submodulesControllers {
            guard let view = viewController.view as? ProfileScreenScrollablePageViewProtocol else {
                continue
            }

            var topOffset = view.contentOffset.y

            // Scrolling down
            if topOffset != topOffsetOfCurrentTab && topOffset <= maxTopOffset {
                topOffset = min(topOffsetOfCurrentTab, maxTopOffset)
            }

            // Scrolling up
            if topOffset > maxTopOffset && topOffsetOfCurrentTab <= maxTopOffset {
                topOffset = min(topOffsetOfCurrentTab, maxTopOffset)
            }

            view.contentOffset = CGPoint(
                x: view.contentOffset.x,
                y: topOffset
            )
        }
    }

}

extension ProfileScreenViewController: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        availableTabs.count
    }
    
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
        self.updateContentInset(headerHeight: self.lastKnownHeaderHeight)
        return self.submodulesControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: ProfileScreenDataFlow.Tab.posts.rawValue)
    }
        
    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        self.profileScreenView.updateCurrentPageIndex(index)
        self.viewModel.doSubmoduleControllerAppearanceUpdate(request: .init(submoduleIndex: index))
    }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        willScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) { }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollTo position: CGPoint,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) { }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didReloadWith currentViewController: UIViewController,
        currentPageIndex: PageboyViewController.PageIndex
    ) { }
}

extension ProfileScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastKnownScrollOffset = scrollView.contentOffset.y
        self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
    }
}

extension ProfileScreenViewController: ProfileScreenViewControllerProtocol {
    func displayProfile(viewModel: ProfileScreenDataFlow.ProfileLoad.ViewModel) {
        guard case let .result(headerData, posts, comments, subscribers) = viewModel.state else { return }
        self.title = "@" + headerData.name
        self.storedViewModel = headerData
        profileScreenView.configure(viewData: headerData)
        
        self.viewModel.doSubmodulesDataFilling(request: .init(submodules: submoduleInputs,
                                                              posts: posts,
                                                              comments: comments,
                                                              subscribers: subscribers))
    }
    
    func displayNotBlockingActivityIndicator( viewModel: ProfileScreenDataFlow.ShowingActivityIndicator.ViewModel) {
         viewModel.shouldDismiss
            ? self.profileScreenView.hideActivityIndicatorView()
            : self.profileScreenView.showActivityIndicatorView()
    }
    
    func displayMoreButtonAlert(viewModel: ProfileScreenDataFlow.IdentifyProfile.ViewModel) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = showMoreBarButton
        
        if viewModel.isCurrentProfile {
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                self.viewModel.doProfileLogout()
                _ = self.styledNavigationController?.popViewController(animated: true)
            }
            
            alert.addAction(logoutAction)
            
        } else {
            
            let sendMessageAction = UIAlertAction(title: "Send Message", style: .default) { _ in
                guard let recipientId = self.viewModel.loadedProfile?.id else {
                    Logger.commonLog.error("Can't get id form loaded profile")
                    return
                }
                
                self.coordinator?.goToWriteMessage(recipientId: recipientId)
            }
                        
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                // Ha-ha
                UIAlertController.createOkAlert(message: "You've blocked user!")
            }
            
            alert.addAction(blockAction)
            alert.addAction(sendMessageAction)
        }
        
        let chooseInstanceAction = UIAlertAction(title: "Choose another instance", style: .default) { (_) in
            self.coordinator?.goToInstances()
        }
        
        alert.addAction(chooseInstanceAction)
        alert.addAction(UIAlertAction.cancelAction)
        
        self.present(alert, animated: true)
    }
}

extension ProfileScreenViewController: ProfileScreenViewDelegate {
    func numberOfPages(in courseInfoView: ProfileScreenViewController.View) -> Int {
        self.submodulesControllers.count
    }
    
    func profileView(_ profileView: View, didRequestScrollToPage index: Int) {
        self.pageViewController.scrollToPage(.at(index: index), animated: true)
    }

    func profileView(_ profileView: View, didReportNewHeaderHeight height: CGFloat) {
        self.lastKnownHeaderHeight = height
        self.updateContentInset(headerHeight: self.lastKnownHeaderHeight)
    }
}

extension ProfileScreenViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .init(
            shadowViewAlpha: 0.0,
            backgroundColor: StyledNavigationController.Appearance.backgroundColor.withAlphaComponent(0.0),
            statusBarColor: StyledNavigationController.Appearance.statusBarColor.withAlphaComponent(0.0),
            textColor: StyledNavigationController.Appearance.tintColor.withAlphaComponent(0.0),
            tintColor: .label,
            statusBarStyle: .default
        )
    }
}
