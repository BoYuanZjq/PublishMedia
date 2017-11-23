//
//  FBFriendCircleCell.h
//  PublishMedia
//
//  Created by derek on 2017/11/22.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFriendCommentModel.h"

@class FBFriendCircleCell;

@protocol FBFriendCircleCellDelegate <NSObject>
//点击喜欢
- (void)didClickLikeButtonInCell:(FBFriendCircleCell *)cell;
//点击评论
- (void)didClickcCommentButtonInCell:(FBFriendCircleCell *)cell;

@end

@interface FBFriendCircleCell : UITableViewCell

@property (nonatomic, weak) id<FBFriendCircleCellDelegate> delegate;

@property (nonatomic, strong) FBFriendCommentModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
