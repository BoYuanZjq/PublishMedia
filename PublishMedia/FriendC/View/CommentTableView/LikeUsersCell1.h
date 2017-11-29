//
//  LikeUsersCell1.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFriendCommentModel.h"
#import "MLLinkLabel.h"

@class FriendInfoModel;

typedef void(^TapNameBlock)(NSString *userID);
@interface LikeUsersCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet MLLinkLabel *likeUsersLabel;
@property(nonatomic ,copy)TapNameBlock tapNameBlock;

@property(nonatomic ,strong)FBFriendCommentModel *model;

@end
