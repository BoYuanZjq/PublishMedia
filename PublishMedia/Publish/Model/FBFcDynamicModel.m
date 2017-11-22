//
//  FBFcDynamicModel.m
//  PublishMedia
//
//  Created by derek on 2017/11/21.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFcDynamicModel.h"

@implementation FBFcDynamicModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.picArray = [[NSMutableArray alloc] init];
        self.selectedAssets = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
