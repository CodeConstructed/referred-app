//
//  PostShowMoreHandlerService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ShowMoreHandlerServiceProtocol {
    func showMoreInPost(on viewController: UIViewController,
                        coordinator: BaseCoordinator,
                        post: LemmyModel.PostView)
    func showMoreInComment(on viewController: UIViewController,
                           coordinator: BaseCoordinator,
                           comment: LemmyModel.CommentView)
    func showMoreInReply(on viewController: InboxRepliesViewController,
                         coordinator: BaseCoordinator,
                         reply: LemmyModel.ReplyView)
    func showMoreInUserMention(on viewController: InboxMentionsViewController,
                               coordinator: BaseCoordinator,
                               mention: LemmyModel.UserMentionView)
}

class ShowMoreHandlerService: ShowMoreHandlerServiceProtocol {
    
    private let networkService: RequestsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: RequestsManager = ApiManager.requests
    ) {
        self.networkService = networkService
    }
        
    func showMoreInPost(
        on viewController: UIViewController,
        coordinator: BaseCoordinator,
        post: LemmyModel.PostView
    ) {
        
        let alertController = createActionSheetController(vc: viewController)

        let shareAction = self.createShareAction(on: viewController, urlString: post.apId)
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportPost(over: viewController, post: post)
            }
        }
        
        alertController.addActions([
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        viewController.present(alertController, animated: true)
    }
        
    func showMoreInComment(
        on viewController: UIViewController,
        coordinator: BaseCoordinator,
        comment: LemmyModel.CommentView
    ) {
        let alertController = createActionSheetController(vc: viewController)
        
        let shareAction = self.createShareAction(on: viewController, urlString: comment.getApIdRelatedToPost())
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: comment.id)
            }
        }

        alertController.addActions([
            shareAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInReply(
        on viewController: InboxRepliesViewController,
        coordinator: BaseCoordinator,
        reply: LemmyModel.ReplyView
    ) {
        let alertController = createActionSheetController(vc: viewController)

        let sendMessageAction = UIAlertAction(title: "Send Message", style: .default) { _ in
            let recipientId = reply.creatorId
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            
            ContinueIfLogined(on: viewController, coordinator: coordinator) {
                self.reportComment(over: viewController, contentId: reply.id)
            }
        }
        
        alertController.addActions([
            sendMessageAction,
            reportAction,
            UIAlertAction.cancelAction
        ])
        viewController.present(alertController, animated: true)
    }
    
    func showMoreInUserMention(
        on viewController: InboxMentionsViewController,
        coordinator: BaseCoordinator,
        mention: LemmyModel.UserMentionView
    ) {
        let alertController = createActionSheetController(vc: viewController)

        let sendMessageAction = UIAlertAction(title: "Send Message", style: .default) { _ in
            let recipientId = mention.creatorId
            viewController.coordinator?.goToWriteMessage(recipientId: recipientId)
        }
        
        alertController.addAction(sendMessageAction)
        alertController.addAction(UIAlertAction.cancelAction)
        viewController.present(alertController, animated: true)
    }
    
    private func createActionSheetController(vc: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.permittedArrowDirections = []
        alertController.popoverPresentationController?.sourceRect = CGRect(
            x: (vc.view.bounds.midX),
            y: (vc.view.bounds.midY),
            width: 0,
            height: 0
        )
        alertController.popoverPresentationController?.sourceView = vc.view
        return alertController
    }
    
    private func createShareAction(on viewController: UIViewController, urlString: String) -> UIAlertAction {
        return UIAlertAction(title: "Share", style: .default, handler: { (_) in
            
            if let url = URL(string: urlString) {
                
                let safariActiv = SafariActivity(url: url)
                
                let activityVc = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: [safariActiv]
                )
                
                if let popoverController = activityVc.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                                          y: UIScreen.main.bounds.height / 2,
                                                          width: 0,
                                                          height: 0)
                    popoverController.sourceView = viewController.view
                    popoverController.permittedArrowDirections = []
                }
                
                viewController.present(activityVc, animated: true)
            }
        })
    }
    
    private func showAlertWithTextField(
        over viewController: UIViewController,
        reportAction: @escaping (String) -> Void
    ) {
        let controller = UIAlertController(title: nil, message: "Reason", preferredStyle: .alert)
        controller.addTextField(configurationHandler: { tf in
            tf.placeholder = "Text here"
        })
        
        controller.addActions([
            UIAlertAction(title: "Cancel", style: .cancel),
            UIAlertAction(title: "Report", style: .default, handler: { _ in
                if let textFieldText = controller.textFields!.first!.text, !textFieldText.isEmpty {
                    reportAction(textFieldText)
                } else {
                    self.showAlertWithTextField(over: viewController, reportAction: reportAction)
                }
            })
        ])
        
        viewController.present(controller, animated: true)
    }
    
    private func showWasReportedAlert(over viewController: UIViewController) {
        let action = UIAlertController(title: nil, message: "Thank you", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(action, animated: true)
    }
    
    fileprivate func reportPost(over viewController: UIViewController, post: LemmyModel.PostView) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
            let params = LemmyModel.Post.CreatePostReportRequest(postId: post.id,
                                                                 reason: reportReason,
                                                                 auth: jwtToken)
            
            self.networkService
                .asyncCreatePostReport(parameters: params)
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { (response) in
                    
                    if response.success {
                        self.showWasReportedAlert(over: viewController)
                    }
                    
                }.store(in: &self.cancellables)
        }
    }
    
    fileprivate func reportComment(over viewController: UIViewController, contentId: Int) {
        self.showAlertWithTextField(over: viewController) { reportReason in
            
            guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
            let params = LemmyModel.Comment.CreateCommentReportRequest(
                commentId: contentId,
                reason: reportReason,
                auth: jwtToken
            )
            
            self.networkService.asyncCreateCommentReport(parameters: params)
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    Logger.logCombineCompletion(completion)
                } receiveValue: { (response) in
                    
                    if response.success {
                        self.showWasReportedAlert(over: viewController)
                    }
                    
                }.store(in: &self.cancellables)
        }
    }
}
