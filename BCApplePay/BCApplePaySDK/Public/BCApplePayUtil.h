//
//  BCPay.h
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionaryUtils.h"
#import "NSString+IsValid.h"
#import "BCApplePayReq.h"

@protocol BCApplePayDelegate <NSObject>
@required
/**
 *  不同类型的请求，对应不同的响应
 *
 *  @param resp 响应体
 */
- (void)onBCApplePayResp:(id)resp;

@end

@interface BCApplePayUtil : NSObject

/**
 *  全局初始化
 *
 *  @param appId     BeeCloud平台APPID
 *  @param appSecret BeeCloud平台APPSECRET
 */
+ (void)initWithAppID:(NSString *)appId;

/**
 *  设置接收消息的对象
 *
 *  @param delegate BeeCloudDelegate对象，用来接收BeeCloud触发的消息。
 */
+ (void)setBeeCloudDelegate:(id<BCApplePayDelegate>)delegate;

/**
 *  BCPay Delegate
 *
 *  @return delegate
 */
+ (id<BCApplePayDelegate>)getBeeCloudDelegate;

/**
 *  获取API版本号
 *
 *  @return 版本号
 */
+ (NSString *)getBCApiVersion;

/**
 *  处理错误回调
 *
 *  @param resultMsg resultMsg description
 *  @param errMsg    errMsg description
 */
+ (void)doErrorResponse:(NSString *)resultMsg errDetail:(NSString *)errMsg;

#pragma mark - Send BeeCloud Request

@end
