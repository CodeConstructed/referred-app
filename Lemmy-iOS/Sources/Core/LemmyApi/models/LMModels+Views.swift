//
//  LMModels+Views.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    enum Views {
        
        export interface UserViewSafe {
          user: UserSafe;
          counts: UserAggregates;
        }

        export interface UserViewDangerous {
          user: User_;
          counts: UserAggregates;
        }

        export interface UserMentionView {
          user_mention: UserMention;
          comment: Comment;
          creator: UserSafe;
          post: Post;
          community: CommunitySafe;
          recipient: UserSafe;
          counts: CommentAggregates;
          creator_banned_from_community: boolean; // Left Join to CommunityUserBan
          subscribed: boolean; // Left join to CommunityFollower
          saved: boolean; // Left join to CommentSaved
          my_vote?: number; // Left join to CommentLi,
        }

        export interface SiteView {
          site: Site;
          creator: UserSafe;
          counts: SiteAggregates;
        }

        export interface PrivateMessageView {
          private_message: PrivateMessage;
          creator: UserSafe;
          recipient: UserSafe;
        }

        export interface PostView {
          post: Post;
          creator: UserSafe;
          community: CommunitySafe;
          creator_banned_from_community: boolean; // Left Join to CommunityUserBan
          counts: PostAggregates;
          subscribed: boolean; // Left join to CommunityFollower
          saved: boolean; // Left join to PostSaved
          read: boolean; // Left join to PostRead
          my_vote?: number; // Left join to PostLi,
        }

        export interface PostReportView {
          post_report: PostReport;
          post: Post;
          community: CommunitySafe;
          creator: UserSafe;
          post_creator: UserSafe;
          resolver?: UserSafe;
        }

        export interface CommentView {
          comment: Comment;
          creator: UserSafe;
          recipient?: UserSafe; // Left joins to comment and us,
          post: Post;
          community: CommunitySafe;
          counts: CommentAggregates;
          creator_banned_from_community: boolean; // Left Join to CommunityUserBan
          subscribed: boolean; // Left join to CommunityFollower
          saved: boolean; // Left join to CommentSaved
          my_vote?: number; // Left join to CommentLi,
        }

        export interface CommentReportView {
          comment_report: CommentReport;
          comment: Comment;
          post: Post;
          community: CommunitySafe;
          creator: UserSafe;
          comment_creator: UserSafe;
          resolver?: UserSafe;
        }

        export interface ModAddCommunityView {
          mod_add_community: ModAddCommunity;
          moderator: UserSafe;
          community: CommunitySafe;
          modded_user: UserSafe;
        }

        export interface ModAddView {
          mod_add: ModAdd;
          moderator: UserSafe;
          modded_user: UserSafe;
        }

        export interface ModBanFromCommunityView {
          mod_ban_from_community: ModBanFromCommunity;
          moderator: UserSafe;
          community: CommunitySafe;
          banned_user: UserSafe;
        }

        export interface ModBanView {
          mod_ban: ModBan;
          moderator: UserSafe;
          banned_user: UserSafe;
        }

        export interface ModLockPostView {
          mod_lock_post: ModLockPost;
          moderator: UserSafe;
          post: Post;
          community: CommunitySafe;
        }

        export interface ModRemoveCommentView {
          mod_remove_comment: ModRemoveComment;
          moderator: UserSafe;
          comment: Comment;
          commenter: UserSafe;
          post: Post;
          community: CommunitySafe;
        }

        export interface ModRemoveCommunityView {
          mod_remove_community: ModRemoveCommunity;
          moderator: UserSafe;
          community: CommunitySafe;
        }

        export interface ModRemovePostView {
          mod_remove_post: ModRemovePost;
          moderator: UserSafe;
          post: Post;
          community: CommunitySafe;
        }

        export interface ModStickyPostView {
          mod_sticky_post: ModStickyPost;
          moderator: UserSafe;
          post: Post;
          community: CommunitySafe;
        }

        export interface CommunityFollowerView {
          community: CommunitySafe;
          follower: UserSafe;
        }

        export interface CommunityModeratorView {
          community: CommunitySafe;
          moderator: UserSafe;
        }

        export interface CommunityUserBanView {
          community: CommunitySafe;
          user: UserSafe;
        }

        export interface CommunityView {
          community: CommunitySafe;
          creator: UserSafe;
          category: Category;
          subscribed: boolean;
          counts: CommunityAggregates;
        }
        
    }
}
