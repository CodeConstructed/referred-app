//
//  CommentRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol CommentRequestManagerProtocol {
    func getComments(
        parameters: LemmyApiStructs.Comment.GetCommentsRequest,
        completion: @escaping ((Result<LemmyApiStructs.Comment.GetCommentsResponse, LemmyGenericError>) -> Void)
    )
}

extension RequestsManager: CommentRequestManagerProtocol {
    func getComments(
        parameters: LemmyApiStructs.Comment.GetCommentsRequest,
        completion: @escaping ((Result<LemmyApiStructs.Comment.GetCommentsResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Comment.getComments.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
