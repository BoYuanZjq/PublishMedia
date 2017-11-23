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

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<FBFriendLikeModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<FBFriendCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end

@interface FBFriendLikeModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end

@interface FBFriendCommentItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


