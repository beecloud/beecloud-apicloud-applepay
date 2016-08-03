//
//  BCPay.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/8/11.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCApplePay.h"
#import "BCPay.h"
#import "BCPayConstant.h"
#import "BCPayUtil.h"
#import "UZAppDelegate.h"
#import "UZAppUtils.h"
#import "NSDictionaryUtils.h"
#import "JSON.h"

@interface BCApplePay ()<UIApplicationDelegate, BeeCloudDelegate> {
    NSInteger _cbId;
}

@end

@implementation BCApplePay

- (void)pay:(NSDictionary *)paramDic {
    NSLog(@"do pay");
    
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = PayChannelApple;
    payReq.title = [paramDic stringValueForKey:@"title" defaultValue:@""];
    payReq.totalFee = [NSString stringWithFormat:@"%ld",(long)[paramDic integerValueForKey:@"totalfee" defaultValue:0]];
    payReq.billNo = [paramDic stringValueForKey:@"billno" defaultValue:@""];
    payReq.scheme = [[theApp getFeatureByName:kKeyMoudleName] stringValueForKey:kKeyUrlScheme defaultValue:nil];
    payReq.cardType = [paramDic integerValueForKey:@"cardType" defaultValue:0];
    payReq.viewController = self.viewController;
    payReq.optional = [paramDic dictValueForKey:@"optional" defaultValue:nil];
    [BCPay sendBCReq:payReq];
}

- (void)getApiVersion:(NSDictionary *)paramDic {
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    [self sendResultEventWithCallbackId:_cbId dataDict:@{@"apiVersion":kApiVersion} errDict:nil doDelete:YES];
}

- (void)canMakeApplePayments:(NSDictionary *)paramDic {
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    NSUInteger cardType = [paramDic integerValueForKey:@"cardType" defaultValue:0];
    [self sendResultEventWithCallbackId:_cbId dataDict:@{@"status":@([BCPay canMakeApplePayments:cardType])} errDict:nil doDelete:YES];
}

- (NSString *)genOutTradeNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)onBeeCloudResp:(id)resp {
    if (_cbId >= 0) {
        [self sendResultEventWithCallbackId:_cbId dataDict:(NSDictionary *)resp errDict:nil doDelete:YES];
    }
}

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        [theApp addAppHandle:self];
        [BCPay setBeeCloudDelegate:self];
    }
    return self;
}

- (void)dispose {
    [theApp removeAppHandle:self];
}

+ (void)launch {
    NSLog(@"launch");

    NSDictionary *feature = [theApp getFeatureByName:kKeyMoudleName];
    NSString *bcAppid = [feature stringValueForKey:kKeyBCAppID defaultValue:nil];
    [BCPayCache sharedInstance].sandbox = [feature boolValueForKey:kKeySandbox defaultValue:NO];
    
    if (bcAppid.isValid) {
        [BCPay initWithAppID:bcAppid];
    }
}

@end
