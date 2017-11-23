//
//  FcVisit.h
//  FireBall
//
//  Created by derek on 2017/11/19.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ScuessWithNoData)(BOOL isScuess, int responseCode);
typedef void(^ScuessWithData)(BOOL isScuess, id responseData);
typedef void(^FailBlock)(NSError *error,BOOL isNetError);

@interface FcVisit : NSObject

/**
 用户获取朋友圈状态的详情

 @param userId 用户Id
 @param fctrId 该条状态的Id
 @param scuesBlock data
 @param failBlock error
 */
+ (void)fc_get_detail:(NSString*)userId withfc_tr_id:(NSString*)fctrId withReturnData:(ScuessWithData)scuesBlock withFail:(FailBlock)failBlock;

+ (void)fc_get_list:(NSString*)userId withCategory:(int)category withDeviceId:(NSString*)deviceId withDeviceType:(NSString*)type withCateid:(NSString*)cateId withRow:(int)row;

/**
 为其朋友圈点赞

 @param userID 用户id
 @param fc_tr_Id 动态id
 @param deviceID 设备id
 @param u_icon 用户头像
 @param acstoken token
 @param scuessBlock data
 @param failBlock error
 */
+ (void)fc_ilike:(NSString*)userID withFc_tr_Id:(NSString*)fc_tr_Id withDeviceId:(NSString*)deviceID withU_icon:(NSString*)u_icon withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock;


/**
 取消为其朋友圈点的赞

 @param userID 用户id
 @param fc_tr_Id 动态id
 @param acstoken token
 @param scuessBlock data
 @param failBlock error
 */
+ (void)fc_ilike_u:(NSString*)userID withFc_tr_Id:(NSString*)fc_tr_Id withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock;

/**
 回复动态

 @param fc_tr_Id 动态id
 @param deviceID 设备id
 @param userId 用户id
 @param userName 名字id
 @param u_icon 头像
 @param replyid 回复的评论ID
 @param replyuid 回复对象的ID,可以为空(即作者)
 @param replyname 回复对象的名称
 @param content 回复的内容
 @param acstoken AccessToken
 @param scuessBlock data
 @param failBlock error
 */
+ (void)fc_reply:(NSString*)fc_tr_Id withDeviceId:(NSString*)deviceID withUserId:(NSString*)userId withUserName:(NSString*)userName withUIcon:(NSString*)u_icon withReplayId:(NSString*)replyid withReplyuid:(NSString*)replyuid withreplyname:(NSString*)replyname withreplyContent:(NSString*)content withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock;

/**
 发布新闻

 @param userId 用户id
 @param uName 名称
 @param uIcon 头像
 @param cateId 指定类别的ID
 @param title 标题
 @param content 内容
 @param medias medias
 @param acstoken AccessToken
 @param scuessBlock data
 @param failBlock error
 */
+(void)publish_fc:(NSString*)userId withUname:(NSString*)uName withUicon:(NSString*)uIcon withCateId:(NSString*)cateId withTitle:(NSString*)title withContent:(NSString*)content withMedias:(NSString*)medias withAccessToken:(NSString *)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock;
@end
