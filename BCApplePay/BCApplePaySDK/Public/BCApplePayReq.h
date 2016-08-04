//
//  BCPayReq.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BCApplePayConstant.h"
#import "UPAPayPlugin.h"
#import <PassKit/PassKit.h>

#pragma mark BCPayReq
/**
 *  Pay Request请求结构体
 */
@interface BCApplePayReq : NSObject<UPAPayPluginDelegate> //type=101

/**
 *  订单描述,32个字节内,最长16个汉字。必填
 */
@property (nonatomic, retain) NSString *title;
/**
 *  支付金额,以分为单位,必须为正整数,100表示1元。必填
 */
@property (nonatomic, retain) NSString *totalFee;
/**
 *  商户系统内部的订单号,8~32位数字和/或字母组合,确保在商户系统中唯一。必填
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  订单失效时间,必须为非零正整数，单位为秒，建议不小于300。选填
 */
@property (nonatomic, assign) NSInteger billTimeOut;
/**
 *  银联支付或者Sandbox环境必填
 */
@property (nonatomic, retain) UIViewController *viewController;
/**
 *  Apple Pay必填，0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
 */
@property (nonatomic, assign) NSUInteger cardType;
/**
 *  扩展参数,可以传入任意数量的key/value对来补充对业务逻辑的需求;此参数会在webhook回调中返回;
 */
@property (nonatomic, retain) NSDictionary *optional;
/**
 *  用于统计分析的数据
 */
@property (nonatomic, retain) NSMutableDictionary *analysis;

#pragma mark - Functions

/**
 *  发起支付
 */
- (void)applePayReq;

/**
 *  判断是否支持Apple Pay
 *
 *  @return 支持返回YES
 */
- (BOOL)canMakeApplePayments;

@end
