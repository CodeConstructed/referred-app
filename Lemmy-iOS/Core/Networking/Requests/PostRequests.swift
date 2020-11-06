//
//  PostRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyPostRequestManagerProtocol {
    func getPosts(
        parameters: LemmyModel.Post.GetPostsRequest,
        completion: @escaping ((Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) -> Void)
    )
    
    func getPost(
        parameters: LemmyModel.Post.GetPostRequest,
        completion: @escaping ((Result<LemmyModel.Post.GetPostResponse, LemmyGenericError>) -> Void)
    )
    
    func createPost(
        parameters: LemmyModel.Post.CreatePostRequest,
        completion: @escaping ((Result<LemmyModel.Post.CreatePostResponse, LemmyGenericError>) -> Void)
    )
}

extension RequestsManager: LemmyPostRequestManagerProtocol {
    func getPosts(
        parameters: LemmyModel.Post.GetPostsRequest,
        completion: @escaping ((Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) -> Void)
    ) {

        return requestDecodable(
            path: WSEndpoint.Post.getPosts.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getPost(
        parameters: LemmyModel.Post.GetPostRequest,
        completion: @escaping ((Result<LemmyModel.Post.GetPostResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: WSEndpoint.Post.getPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func createPost(
        parameters: LemmyModel.Post.CreatePostRequest,
        completion: @escaping ((Result<LemmyModel.Post.CreatePostResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: WSEndpoint.Post.createPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
