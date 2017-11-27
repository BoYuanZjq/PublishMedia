//
//  FBFriendCommentModel.h
//  PublishMedia
//
//  Created by derek on 2017/11/23.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBFriendCommentItemModel,FBFriendLikeModel;

@interface FBFriendCommentModel : NSObject

@property (nonatomic , copy) NSString              * fc_tr_id;
@property (nonatomic , copy) NSString              * tr_title;
// 内容
@property (nonatomic , copy) NSString              * tr_content;
@property (nonatomic , copy) NSString              * tr_u_id;
@property (nonatomic , copy) NSString              * tr_u_name;
@property (nonatomic , copy) NSString              * tr_u_icon;
@property (nonatomic , assign) BOOL                tr_ilike;

@property (nonatomic , copy) NSString              * tr_icomment;
@property (nonatomic , copy) NSString              * tr_belong_to;
@property (nonatomic , copy) NSString              * tr_pub_at;
//图片
@property (nonatomic , copy) NSString              * tr_attach;

@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, strong) NSArray<FBFriendLikeModel *> *tr_ilikes;
@property (nonatomic, strong) NSArray<FBFriendCommentItemModel *> *tr_comments;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end

@interface FBFriendLikeModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *lk_u_id;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end

@interface FBFriendCommentItemModel : NSObject

@property (nonatomic, copy) NSString *c_u_name;
@property (nonatomic, copy) NSString *c_u_id;
@property (nonatomic, copy) NSString *c_u_icon;
@property (nonatomic, copy) NSString *c_content;


@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


