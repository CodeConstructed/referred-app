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
        parameters: LemmyApiStructs.Post.GetPostsRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.GetPostsResponse, LemmyGenericError>) -> Void)
    )
    
    func getPost(
        parameters: LemmyApiStructs.Post.GetPostRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.GetPostResponse, LemmyGenericError>) -> Void)
    )
    
    func createPost(
        parameters: LemmyApiStructs.Post.CreatePostRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.CreatePostResponse, LemmyGenericError>) -> Void)
    )
}

extension RequestsManager: LemmyPostRequestManagerProtocol {
    func getPosts(
        parameters: LemmyApiStructs.Post.GetPostsRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.GetPostsResponse, LemmyGenericError>) -> Void)
    ) {

        return requestDecodable(
            path: LemmyEndpoint.Post.getPosts.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func getPost(
        parameters: LemmyApiStructs.Post.GetPostRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.GetPostResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Post.getPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func createPost(
        parameters: LemmyApiStructs.Post.CreatePostRequest,
        completion: @escaping ((Result<LemmyApiStructs.Post.CreatePostResponse, LemmyGenericError>) -> Void)
    ) {
        return requestDecodable(
            path: LemmyEndpoint.Post.createPost.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
