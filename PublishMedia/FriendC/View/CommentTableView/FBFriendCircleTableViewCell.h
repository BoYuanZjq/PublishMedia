//
//  FBFriendCircleTableViewCell.h
//  PublishMedia
//
//  Created by derek on 2017/11/28.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "FBFriendCommentModel.h"
#import "CommentCell1.h"
#import "LikeUsersCell1.h"

@class FBFriendCircleTableViewCell;
@protocol MessageCellDelegate <NSObject>

- (void)reloadCellHeightForModel:(FBFriendCommentModel *)model atIndexPath:(NSIndexPath *)indexPath;

//点击消息cell
- (void)passCellHeight:(CGFloat )cellHeight commentModel:(FBFriendCommentItemModel *)commentModel   commentCell:(CommentCell1 *)commentCell messageCell:(FBFriendCircleTableViewCell *)messageCell;

//点击喜欢
- (void)didClickLikeButtonInCell:(FBFriendCircleTableViewCell *)cell wihtPathIndex:(NSIndexPath*)indexPath;

//点击评论
- (void)didClickcCommentButtonInCell:(FBFriendCircleTableViewCell *)cell wihtPathIndex:(NSIndexPath*)indexPath;


@end

@interface FBFriendCircleTableViewCell : UITableViewCell

@property (nonatomic, strong) JGGView *jggView;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

- (void)configCellWithModel:(FBFriendCommentModel *)model indexPath:(NSIndexPath *)indexPath;

@end
