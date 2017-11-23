//
//  RequestNetUtils.h
//  SingleTalk
//
//  Created by jianqiangzhang on 16/4/25.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, RequestType)
{
    PostType,
    GetType,
    PutTypt,
    UploadFile
};

@interface RequestNetUtils : NSObject

+ (AFHTTPSessionManager*)sessionManager;

+ (void)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params  completion:(void (^)(id responseData,NSError *error))completion;

+ (void)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params withData:(NSData*)data completion:(void (^)(id responseData,NSError *error))completion;

+ (void)requestWithInterface:(NSString *)interfaceStr withRequestType:(RequestType)type withHead:(NSDictionary*)head withBody:(NSData*)data completion:(void (^)(id responseData,NSError *error))completion;


+ (void)requestWithInterfaceStr:(NSString *)interfaceStr parameters:(id)params withData:(NSData*)data withPicName:(NSString*)pictureName completion:(void (^)(id responseData,NSError *error))completion;

+ (void)requestGetWithServerStr:(NSString *)serverStr  completion:(void (^)(id responseData,NSError *error))completion;
@end
