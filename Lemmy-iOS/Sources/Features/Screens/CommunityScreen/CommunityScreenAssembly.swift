//
//  CommunityScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenAssembly: Assembly {
    private let communityId: LemmyModel.CommunityView.Id?
    private let communityName: String?
    
    init(
        communityId: LemmyModel.CommunityView.Id?,
        communityName: String?
    ) {
        self.communityId = communityId
        self.communityName = communityName
    }
    
    func makeModule() -> CommunityScreenViewController {
        let userAccountService = UserAccountService()
        
        let viewModel = CommunityScreenViewModel(communityId: communityId,
                                                 communityName: communityName)
        
        let vc = CommunityScreenViewController(
            viewModel: viewModel,
            followService: CommunityFollowService(
                userAccountService: userAccountService
            ),
            contentScoreService: ContentScoreService(
                userAccountService: userAccountService
            ),
            showMoreService: ShowMoreHandlerService()
            
        )
        viewModel.viewController = vc
        
        return vc
    }
}
