//
//  AutoCommon.h
//  51AutoPersonNew
//
//  Created by jh on 16/3/8.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>
#import "UIDevice+RTCDevice.h"

static NSString * _Nullable UUID = @"";

//typedef enum {
//    kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
//    kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
//    kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
//    kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据
//} CLAuthorizationStatus;

@interface AutoCommon : NSObject

// 获取uuid
+ (NSString *)getUUID;


+ (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text;

//颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

//  获取IP
+ (NSString *)getIPAddress;

// 获取版本号
+ (NSString *)getCurrentIOSVersion;

//获取当前时间
+ (NSString *)getCurrentTime;

//获取手机类型(eg:iphone6s)
+ (NSString *)getPhoneType;

// 获取当前版本
+ (NSString *)getSoftWareVersion;

// 获取当前版本的具体参数
+ (NSString *)getSoftWareVersionFull;

//获取系统当前语言
+ (NSString *)getLanguageFromSystem;

// 将16进制颜色转换成UIColor
+(UIColor *)getColor:(NSString *)color;

//判断是否有网
+ (BOOL)isEnbnleNet;

//判断是否移动网络
+ (BOOL)isEnableWAN;

//关闭所有键盘
+ (void)hideKeyBoard;

//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string;

//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//邮箱验证
+ (BOOL)isAvailableEmail:(NSString *)email;

// 处理手机号
+ (NSString*)dealPhoneNum:(NSString*)phoneNum;

// 根据国家名称查找国家区号
+ (NSString*)findCodeWithCity:(NSString*)city;

//全屏截图
+ (UIImage *)shotScreen;

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

//截取view生成一张图片  最大宽度 （高质量）
+ (UIImage *)screenshot:(UIView *)aView limitWidth:(CGFloat)maxWidth;

//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

//压缩图片到指定文件大小 size :M
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

// 转换json字符串
+(NSString *)toJSON:(id)aParam;

//字符串转字典
+(NSDictionary *)dicWithJSonStr:(NSString *)jsonString;

// data 类型转字典
+ (id)JSONObjectWithData:(NSData *)data;

/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;

/*
 对图片进行滤镜处理
 怀旧 -> CIPhotoEffectInstant                         单色 -> CIPhotoEffectMono
 黑白 -> CIPhotoEffectNoir                            褪色 -> CIPhotoEffectFade
 色调 -> CIPhotoEffectTonal                           冲印 -> CIPhotoEffectProcess
 岁月 -> CIPhotoEffectTransfer                        铬黄 -> CIPhotoEffectChrome
 CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

/*
对图片进行模糊处理
CIGaussianBlur -> 高斯模糊
CIBoxBlur      -> 均值模糊(Available in iOS 9.0 and later)
CIDiscBlur     -> 环形卷积模糊(Available in iOS 9.0 and later)
CIMedianFilter -> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
CIMotionBlur   -> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//毛玻璃效果   Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
//间距
+ (NSDictionary *)setTextLineSpaceWithString:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace withTextlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing;

//是否有访问相册的权限
+ (BOOL)isCanUsePhotos;

//缓存大小
+ (NSString *)cacheSize;

//获取最上层的UIViewController
+ (UIViewController *)topViewController;

#pragma mark - 
// 根据时间戳得到友好时间 ： 08月11日 星期三
+ (NSString*)amityTimeHotSectionTitle:(NSString*)timestamp;
// 根据时间戳得到具体时间： 18:23
+ (NSString*)amityTimeHotGameTimeInfo:(NSString*)timestamp;
//获取时间戳
+ (NSString*)getYYMMDD:(NSString*)timestamp;
//获取时间戳
+(NSString*)getFriendTime:(int64_t)timestamp;

+ (BOOL)canRefreshWithLastData:(NSDate*)lastDate;

typedef void(^DeleteCacheBlock)(void);
//清理缓存
+ (void)deleteCache:( nullable DeleteCacheBlock)block;

/**
 *  延迟加载
 */
extern void delayOperation(float time,void (^block)(void));
/**
 *  主线程块
 */
extern void main_block(void (^block)(void));
/**
 *  异步块
 */
extern void async_block(void (^block)(void));
/**
 *  是否为字符串
 */
extern BOOL isString(id aid);

/**
 *  是否为数组
 */
extern BOOL isArray(id aid);

/**
 *  是否为字典
 */
extern BOOL isDictionary(id aid);

/**
 *  客户端版本-内部版本
 */
extern NSString *Tool_CFVersion(void);
/**
 *  客户端外部版本号
 */
extern NSString *Tool_CFVersionString(void);

@end
