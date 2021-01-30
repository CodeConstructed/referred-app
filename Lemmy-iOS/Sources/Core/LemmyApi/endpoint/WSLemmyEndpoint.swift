//
//  WSLemmyEndpoint.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum WSEndpoint {

    // User / Authentication / Admin actions
    enum Authentication {
        case login
        case register
        case getCaptcha

        var endpoint: String {
            switch self {
            case .login: return "Login"
            case .register: return "Register"
            case .getCaptcha: return "GetCaptcha"
            }
        }
    }

    enum User {
        case userJoin
        
        case getUserDetails
        case saveUserSettings
        case getReplies         // Get Replies / Inbox
        case getUserMentions
        case markUserMentionAsRead

        case getPrivateMessages
        case createPrivateMessage
        case editPrivateMessage
        case deletePrivateMessage
        case markPrivateMessageAsRead
        case markAllAsRead

        case deleteAccount // Permananently deletes your posts and comments

        var endpoint: String {
            switch self {
            case .userJoin: return "UserJoin"
            case .getUserDetails: return "GetUserDetails"
            case .saveUserSettings: return "SaveUserSettings"
            case .getReplies: return "GetReplies"
            case .getUserMentions: return "GetUserMentions"
            case .markUserMentionAsRead: return "MarkUserMentionAsRead"
            case .getPrivateMessages: return "GetPrivateMessages"
            case .createPrivateMessage: return "CreatePrivateMessage"
            case .editPrivateMessage: return "EditPrivateMessage"
            case .deletePrivateMessage: return "DeletePrivateMessage"
            case .markPrivateMessageAsRead: return "MarkPrivateMessageAsRead"
            case .markAllAsRead: return "MarkAllAsRead"
            case .deleteAccount: return "DeleteAccount"
            }
        }

    }

    enum AdminActions {
        case addAdmin
        case banUser

        var endpoint: String {
            switch self {
            case .addAdmin: return "AddAdmin"
            case .banUser: return "BanUser"
            }
        }
    }

    enum Site {
        case listCategories
        case search // All, Comments, Posts, Communities, Users, Url
        case getModlog
        case createSite
        case editSite
        case getSite
        case transferSite
        case getSiteConfig
        case saveSiteConfig

        var endpoint: String {
            switch self {
            case .listCategories: return "ListCategories"
            case .search: return "Search"
            case .getModlog: return "GetModlog"
            case .createSite: return "CreateSite"
            case .editSite: return "EditSite"
            case .getSite: return "GetSite"
            case .transferSite: return "TransferSite"
            case .getSiteConfig: return "GetSiteConfig"
            case .saveSiteConfig: return "SaveSiteConfig"

            }
        }
    }

    enum Community {
        case communityJoin
        case getCommunity
        case createCommunity
        case listCommunities
        case banFromCommunity
        case addModToCommunity
        case editCommunity
        case deleteCommunity
        case removeCommunity
        case followCommunity
        case getFollowedCommunities
        case transferCommunities

        var endpoint: String {
            switch self {
            case .communityJoin: return "CommunityJoin"
            case .getCommunity: return "GetCommunity"
            case .createCommunity: return "CreateCommunity"
            case .listCommunities: return "ListCommunities"
            case .banFromCommunity: return "BanFromCommunity"
            case .addModToCommunity: return "AddModToCommunity"
            case .editCommunity: return "EditCommunity"
            case .deleteCommunity: return "DeleteCommunity"
            case .removeCommunity: return "RemoveCommunity"
            case .followCommunity: return "FollowCommunity"
            case .getFollowedCommunities: return "GetFollowedCommunities"
            case .transferCommunities: return "TransferCommunities"
            }
        }
    }

    enum Post {
        case createPost
        case getPost
        case getPosts
        case createPostLike
        case editPost
        case deletePost
        case removePost
        case lockPost
        case stickyPost
        case savePost
        case createPostReport
        case resolvePostReport
        case listPostReports

        var endpoint: String {
            switch self {
            case .createPost: return "CreatePost"
            case .getPost: return "GetPost"
            case .getPosts: return "GetPosts"
            case .createPostLike: return "CreatePostLike"
            case .editPost: return "EditPost"
            case .deletePost: return "DeletePost"
            case .removePost: return "RemovePost"
            case .lockPost: return "LockPost"
            case .stickyPost: return "StickyPost"
            case .savePost: return "SavePost"
            case .createPostReport: return "CreatePostReport"
            case .resolvePostReport: return "ResolvePostReport"
            case .listPostReports: return "ListPostReports"
            }
        }
    }

    enum Comment {
        case createComment
        case editComment
        case deleteComment
        case removeComment
        case markCommentAsRead
        case saveComment
        case getComments
        case createCommentLike
        case createCommentReport
        case resolveCommentReport
        case listCommentReports

        var endpoint: String {
            switch self {
            case .createComment: return "CreateComment"
            case .editComment: return "EditComment"
            case .deleteComment: return "DeleteComment"
            case .removeComment: return "RemoveComment"
            case .markCommentAsRead: return "MarkCommentAsRead"
            case .saveComment: return "SaveComment"
            case .getComments: return "GetComments"
            case .createCommentLike: return "CreateCommentLike"
            case .createCommentReport: return "CreateCommentReport"
            case .resolveCommentReport: return "ResolveCommentReport"
            case .listCommentReports: return "ListCommentReports"
            }
        }
    }
}
