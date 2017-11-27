//
//  FBCommentLabel.h
//  PublishMedia
//
//  Created by derek on 2017/11/26.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "MLLinkLabel.h"
#import "FBFriendCommentModel.h"

@interface FBCommentLabel : MLLinkLabel

@property (nonatomic, strong) FBFriendCommentItemModel *commentItem;

@end
