//
//  InboxRepliesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol InboxMessagesViewModelProtocol {
    func doLoadMessages(request: InboxMessages.LoadMessages.Request)
    func doNextLoadMessages(request: InboxMessages.LoadMessages.Request)
}

final class InboxMessagesViewModel: InboxMessagesViewModelProtocol {
    weak var viewController: InboxMessagesViewControllerProtocol?
    
    private let userAccountService: UserAccountService
    
    private var paginationState = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountService
    ) {
        self.userAccountService = userAccountService
    }
    
    func doLoadMessages(request: InboxMessages.LoadMessages.Request) {
        self.paginationState = 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token is found")
            return
        }
        
        let params = LemmyModel.User.GetPrivateMessagesRequest(unread_only: false,
                                                               page: paginationState,
                                                               limit: 50,
                                                               auth: jwt)
        
        ApiManager.requests.asyncGetPrivateMessages(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displayMessages(viewModel: .init(state: .result(response.messages)))
            }.store(in: &cancellables)
    }
    
    func doNextLoadMessages(request: InboxMessages.LoadMessages.Request) {
        self.paginationState += 1
        
        guard let jwt = userAccountService.jwtToken else {
            Logger.commonLog.error("No jwt token is found")
            return
        }
        
        let params = LemmyModel.User.GetPrivateMessagesRequest(unread_only: false,
                                                               page: paginationState,
                                                               limit: 50,
                                                               auth: jwt)
        
        ApiManager.requests.asyncGetPrivateMessages(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displayNextMessages(viewModel: .init(state: .result(response.messages)))
            }.store(in: &cancellables)
    }
}

extension InboxMessagesViewModel: InboxMessagesInputProtocol {
    func update() {
        self.doLoadMessages(request: .init())
    }
    
    func handleControllerAppearance() { }
}

enum InboxMessages {
    enum LoadMessages {
        struct Request { }
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case result([LemmyModel.PrivateMessageView])
        case loading
    }
}
