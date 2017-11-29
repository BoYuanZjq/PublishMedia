//
//  FBFriendCommentView.h
//  PublishMedia
//
//  Created by derek on 2017/11/23.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBFriendCrCommentView : UIView

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

typedef void(^DidSelectedLikeUserBlock)(NSString *userId);
@property (nonatomic, copy) DidSelectedLikeUserBlock selectedUserBlock;

@end
