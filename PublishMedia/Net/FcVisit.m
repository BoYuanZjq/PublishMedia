//
//  FcVisit.m
//  FireBall
//
//  Created by derek on 2017/11/19.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FcVisit.h"
#import "RequestNetUtils.h"
#import "AutoCommon.h"

//// ----朋友圈请求地址-----
#define fcRequestUrl  @""

@implementation FcVisit

+ (void)fc_get_detail:(NSString*)userId withfc_tr_id:(NSString*)fctrId withReturnData:(ScuessWithData)scuesBlock withFail:(FailBlock)failBlock {
   
    if (![AutoCommon isEnbnleNet]) {
        failBlock(nil,YES);
        return;
    }
    
    NSArray *objects = @[userId,fctrId];
    NSArray *keys = [NSArray arrayWithObjects:@"u_id",@"fc_tr_id",nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_get_detail"];
    
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                //NSArray *array = [FBNewModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"n"]];
                //scuesBlock(array, 200);
            } else {
               // scuesBlock(nil, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}

+ (void)fc_get_list:(NSString*)userId withCategory:(int)category withDeviceId:(NSString*)deviceId withDeviceType:(NSString*)type withCateid:(NSString*)cateId withRow:(int)row {
    
    if (![AutoCommon isEnbnleNet]) {
       // failBlock(nil,YES);
        return;
    }
    
    NSArray *objects;
    NSArray *keys;
    
    if (cateId) {
        objects = @[userId,[NSNumber numberWithInt:category],deviceId,type,cateId,[NSNumber numberWithInt:row]];
        keys = [NSArray arrayWithObjects:@"u_id",@"category",@"devtag",@"devtype",@"cateid",@"row",nil];
    }else{
        objects = @[userId,[NSNumber numberWithInt:category],deviceId,type,[NSNumber numberWithInt:row]];
        keys = [NSArray arrayWithObjects:@"u_id",@"category",@"devtag",@"devtype",@"row",nil];
    }
  
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_get_list"];
    
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            //failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                //NSArray *array = [FBNewModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"n"]];
                //scuesBlock(array, 200);
            } else {
                // scuesBlock(nil, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}

+ (void)fc_ilike:(NSString*)userID withFc_tr_Id:(NSString*)fc_tr_Id withDeviceId:(NSString*)deviceID withU_icon:(NSString*)u_icon withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock {
    
    if (![AutoCommon isEnbnleNet]) {
         failBlock(nil,YES);
        return;
    }
    
    NSArray *objects  = @[userID,fc_tr_Id,deviceID,u_icon,acstoken];
    NSArray *keys = [NSArray arrayWithObjects:@"u_id",@"fc_tr_id",@"devtag",@"u_icon",@"acstoken",nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_ilike"];
   
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            //failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                //NSArray *array = [FBNewModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"n"]];
                //scuesBlock(array, 200);
            } else {
                // scuesBlock(nil, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}

+ (void)fc_ilike_u:(NSString*)userID withFc_tr_Id:(NSString*)fc_tr_Id withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock {
    
    if (![AutoCommon isEnbnleNet]) {
        failBlock(nil,YES);
        return;
    }
    
    NSArray *objects  = @[userID,fc_tr_Id,acstoken];
    NSArray *keys = [NSArray arrayWithObjects:@"u_id",@"fc_tr_id",@"acstoken",nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_ilike_u"];
    
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            //failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                //NSArray *array = [FBNewModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"n"]];
                //scuesBlock(array, 200);
            } else {
                // scuesBlock(nil, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}

+ (void)fc_reply:(NSString*)fc_tr_Id withDeviceId:(NSString*)deviceID withUserId:(NSString*)userId withUserName:(NSString*)userName withUIcon:(NSString*)u_icon withReplayId:(NSString*)replyid withReplyuid:(NSString*)replyuid withreplyname:(NSString*)replyname withreplyContent:(NSString*)content withAcstoken:(NSString*)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock {
    
    if (![AutoCommon isEnbnleNet]) {
        failBlock(nil,YES);
        return;
    }
    NSArray *objects;
    NSArray *keys;
    
    if (replyid) {
        objects = @[fc_tr_Id,deviceID,userId,userName,u_icon,replyid,replyuid,replyname,content,acstoken];
        keys = [NSArray arrayWithObjects:@"fc_tr_id",@"devtag",@"u_id",@"u_name",@"u_icon",@"replyid",@"replyuid",@"replyuname",@"replycontent",@"acstoken",nil];
    }else{
        objects = @[fc_tr_Id,deviceID,userId,userName,u_icon,content,acstoken];
        keys = [NSArray arrayWithObjects:@"fc_tr_id",@"devtag",@"u_id",@"u_name",@"u_icon",@"replycontent",@"acstoken",nil];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_reply"];
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                scuessBlock(YES, 200);
            } else {
                scuessBlock(NO, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}

+(void)publish_fc:(NSString*)userId withUname:(NSString*)uName withUicon:(NSString*)uIcon withCateId:(NSString*)cateId withTitle:(NSString*)title withContent:(NSString*)content withMedias:(NSString*)medias withAccessToken:(NSString *)acstoken withReturnData:(ScuessWithNoData)scuessBlock withFail:(FailBlock)failBlock {
   
    if (![AutoCommon isEnbnleNet]) {
        failBlock(nil,YES);
        return;
    }
    NSArray *objects;
    NSArray *keys;
    
    if (cateId) {
        if (title) {
            objects = @[userId,uName,uIcon,cateId,title,content,medias];
            keys = [NSArray arrayWithObjects:@"u_id",@"u_name",@"u_icon",@"cateid",@"title",@"content",@"medias",@"acstoken",nil];
        }else{
            objects = @[userId,uName,uIcon,cateId,content,medias];
            keys = [NSArray arrayWithObjects:@"u_id",@"u_name",@"u_icon",@"cateid",@"content",@"medias",@"acstoken",nil];
        }
      
    }else{
        if (title) {
            objects = @[userId,uName,uIcon,title,content,medias];
            keys = [NSArray arrayWithObjects:@"u_id",@"u_name",@"u_icon",@"title",@"content",@"medias",@"acstoken",nil];
        }else{
            objects = @[userId,uName,uIcon,content,medias];
            keys = [NSArray arrayWithObjects:@"u_id",@"u_name",@"u_icon",@"content",@"medias",@"acstoken",nil];
        }
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",fcRequestUrl,@"fc_reply"];
    [RequestNetUtils requestWithInterfaceStr:url withRequestType:GetType parameters:param completion:^(id responseData, NSError *error) {
        if (error) {
            failBlock(error,NO);
        }else{
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] intValue]==0) {
                scuessBlock(YES, 200);
            } else {
                scuessBlock(NO, [[dict objectForKey:@"code"] intValue]);
            }
        }
    }];
}
@end
