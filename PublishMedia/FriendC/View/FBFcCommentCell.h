//
//  FBFcCommentCell.h
//  PublishMedia
//
//  Created by derek on 2017/11/24.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFriendCommentModel.h"

@class FBFcCommentCell;

@interface FBFcCommentCell : UITableViewCell

@property (nonatomic, strong) FBFriendCommentItemModel *commentModel;

@end
