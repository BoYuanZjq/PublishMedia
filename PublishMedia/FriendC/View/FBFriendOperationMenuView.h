//
//  FBFriendOperationMenuView.h
//  PublishMedia
//
//  Created by derek on 2017/11/23.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBFriendOperationMenuView : UIView

//展示与取消展示
@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(void);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);

@end
