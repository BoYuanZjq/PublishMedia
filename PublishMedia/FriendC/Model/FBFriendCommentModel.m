//
//  FBFriendCommentModel.m
//  PublishMedia
//
//  Created by derek on 2017/11/23.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFriendCommentModel.h"

@implementation FBFriendCommentModel

+ (NSDictionary *)objectClassInArray{
    return @{@"tr_ilikes" : [FBFriendLikeModel class],@"tr_comments":[FBFriendCommentItemModel class]};
}

- (void)setTr_attach:(NSString *)tr_attach {
    _tr_attach = tr_attach;
   
    //去除引号
    tr_attach = [tr_attach stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSArray *childArray = [tr_attach componentsSeparatedByString:@","];
    if (childArray.count!=0) {
        self.picNamesArray = [childArray mutableCopy];
    }else{
        self.picNamesArray = [[NSArray alloc] initWithObjects:tr_attach, nil];
    }
    
}
@end

@implementation FBFriendLikeModel

- (void)setUserName:(NSString *)userName {
    
}

@end

@implementation FBFriendCommentItemModel

@end

