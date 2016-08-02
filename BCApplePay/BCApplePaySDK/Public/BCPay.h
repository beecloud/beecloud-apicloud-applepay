//
//  BCPay.h
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPayObjects.h"
#import "NSString+IsValid.h"

@protocol BeeCloudDelegate <NSObject>
@required
/**
 *  不同类型的请求，对应不同的响应
 *
 *  @param resp 响应体
 */
- (void)onBeeCloudResp:(id)resp;

@end

@interface BCPay : NSObject

/**
 *  全局初始化
 *
 *  @param appId     BeeCloud平台APPID
 *  @param appSecret BeeCloud平台APPSECRET
 */
+ (void)initWithAppID:(NSString *)appId;

/**
 *  判断是否支持Apple Pay
 *
 *  @return 支持返回YES
 */
+ (BOOL)canMakeApplePayments:(NSUInteger)cardType;

/**
 *  设置接收消息的对象
 *
 *  @param delegate BeeCloudDelegate对象，用来接收BeeCloud触发的消息。
 */
+ (void)setBeeCloudDelegate:(id<BeeCloudDelegate>)delegate;

/**
 *  BCPay Delegate
 *
 *  @return delegate
 */
+ (id<BeeCloudDelegate>)getBeeCloudDelegate;

/**
 *  获取API版本号
 *
 *  @return 版本号
 */
+ (NSString *)getBCApiVersion;

/**
 *  设置是否打印log
 *
 *  @param flag YES打印
 */
+ (void)setWillPrintLog:(BOOL)flag;

/**
 *  设置网络请求超时时间
 *
 *  @param time 超时时间, 5.0代表5秒。
 */
+ (void)setNetworkTimeout:(NSTimeInterval)time;

/**
 *  处理错误回调
 *
 *  @param resultMsg resultMsg description
 *  @param errMsg    errMsg description
 */
+ (void)doErrorResponse:(NSString *)resultMsg errDetail:(NSString *)errMsg;

#pragma mark - Send BeeCloud Request

/**
 *  发送BeeCloud Api请求
 *
 *  @param req 请求体
 *
 *  @return 发送请求是否成功
 */
+ (void)sendBCReq:(BCBaseReq *)req;

@end
