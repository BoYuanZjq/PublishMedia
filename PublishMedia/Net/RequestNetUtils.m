//
//  RequestNetUtils.m
//  SingleTalk
//
//  Created by jianqiangzhang on 16/4/25.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "RequestNetUtils.h"
#import "AFNetworking.h"
#import "AutoCommon.h"

//#import "AFAppDotNetAPIClient.h"
typedef enum {
    XNetWorkError = -1000,
}CustomErrorFailed;
#define CustomErrorDomain @"com.dync.FireBall"


@implementation RequestNetUtils
//static AFHTTPSessionManager *manager = nil;

+ (AFHTTPSessionManager*)sessionManager
{

    //return [AFAppDotNetAPIClient sharedClient];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    manager.operationQueue.maxConcurrentOperationCount = 3;
    manager.requestSerializer.timeoutInterval = 6.f;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
// //   manager.securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
//    // 2.设置证书模式
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
//    // 客户端是否信任非法证书
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    // 是否在证书域字段中验证域名
//    [manager.securityPolicy setValidatesDomainName:NO];
    
    return manager;
}

+ (void)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params withData:(NSData*)data completion:(void (^)(id responseData,NSError *error))completion
{
    if (![AutoCommon isEnbnleNet]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"断网了..."                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:CustomErrorDomain code:XNetWorkError userInfo:userInfo];
        completion(nil,error);
        return;
    }
    
    
    NSString *urlStr = interfaceStr;//[NSString stringWithFormat:@"%@/%@",newsRequestUrl,interfaceStr];
    AFHTTPSessionManager *operation = [RequestNetUtils sessionManager];
    switch (type) {
        case 0:
        {
            [operation POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(nil,error);
            }];
            
        }
            break;
        case 1:
        {
            [operation GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(nil,error);
            }];
        }
            break;
        case 2:
        {
            [operation PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(nil,error);
            }];
        }
            break;
        case 3:
        {
            [operation POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDate *senddate = [NSDate date];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
                NSString *locationString = [dateformatter stringFromDate:senddate];
                NSString *photo = [NSString stringWithFormat:@"%@IMG_Headimage.jpg",locationString];
                
                [formData appendPartWithFileData:data
                                            name:@"picture"
                                        fileName:photo mimeType:@"image/jpg"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completion(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(nil,error);
            }];
        }
            break;
            
        default:
            break;
    }
}
+ (void)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params  completion:(void (^)(id responseData,NSError *error))completion
{
    [self requestWithInterfaceStr:interfaceStr withRequestType:type parameters:params withData:nil completion:completion];
}


+ (void)requestGetWithServerStr:(NSString *)serverStr  completion:(void (^)(id responseData,NSError *error))completion {
    if (![AutoCommon isEnbnleNet]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"断网了..."                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:CustomErrorDomain code:XNetWorkError userInfo:userInfo];
        completion(nil,error);
        return;
    }
    // 发起请求
    NSError *error = nil;
    serverStr = [serverStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serverStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6];
    request.HTTPMethod = @"GET";
    // 配置get请求参数(configGetUrlRequestWithMethod方法将在后面介绍) 、接收请求返回数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error) {
        // 如果出错，就输出错误，并回调
        NSLog(@"request did failed with error message '%@'", [error localizedDescription]);
        completion(nil, error);
    } else {
        // JSON解析，回调
        NSMutableDictionary *object =[AutoCommon JSONObjectWithData:data];
        if (object) {
             completion(object, nil);
        }else{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"暂无数据"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:CustomErrorDomain code:XNetWorkError userInfo:userInfo];
             completion(nil, error);
        }
    }
}
@end
