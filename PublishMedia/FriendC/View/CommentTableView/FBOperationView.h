//
//  FBOperationView.h
//  PublishMedia
//
//  Created by derek on 2017/11/29.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBOperationView : UIView
@property(nonatomic,assign)BOOL isShowing;
@property(nonatomic,copy)NSString *praiseString;

//block
@property (nonatomic,copy) void(^zanBtnClickBlock)(void);
@property (nonatomic,copy) void(^commentBtnClickBlock)(void);

@end
