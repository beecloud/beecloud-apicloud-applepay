//
//  BCPay.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/8/11.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCApplePay.h"
#import "BCApplePayUtil.h"
#import "BCApplePayConstant.h"
#import "BCUtil.h"
#import "UZAppDelegate.h"
#import "UZAppUtils.h"
#import "NSDictionaryUtils.h"

@interface BCApplePay ()<UIApplicationDelegate, BCApplePayDelegate> {
    NSInteger _cbId;
}

@end

@implementation BCApplePay

- (void)pay:(NSDictionary *)paramDic {
    NSLog(@"do pay");
    
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    BCApplePayReq *payReq = [[BCApplePayReq alloc] init];
    payReq.title = [paramDic stringValueForKey:@"title" defaultValue:@""];
    payReq.totalFee = [NSString stringWithFormat:@"%ld",(long)[paramDic integerValueForKey:@"totalfee" defaultValue:0]];
    payReq.billNo = [paramDic stringValueForKey:@"billno" defaultValue:@""];
    payReq.cardType = [paramDic integerValueForKey:@"cardType" defaultValue:0];
    payReq.viewController = self.viewController;
    payReq.optional = [paramDic dictValueForKey:@"optional" defaultValue:nil];
    [payReq applePayReq];
}

- (void)getApiVersion:(NSDictionary *)paramDic {
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    [self sendResultEventWithCallbackId:_cbId dataDict:@{@"apiVersion":kApiVersion} errDict:nil doDelete:YES];
}

- (void)canMakeApplePayments:(NSDictionary *)paramDic {
    _cbId = [paramDic integerValueForKey:@"cbId" defaultValue:-1];
    NSUInteger cardType = [paramDic integerValueForKey:@"cardType" defaultValue:0];
    BCApplePayReq *appleReq = [[BCApplePayReq alloc] init];
    appleReq.cardType = cardType;
    [self sendResultEventWithCallbackId:_cbId dataDict:@{@"status":@([appleReq canMakeApplePayments])} errDict:nil doDelete:YES];
}

- (NSString *)genOutTradeNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)onBCApplePayResp:(id)resp {
    if (_cbId >= 0) {
        [self sendResultEventWithCallbackId:_cbId dataDict:(NSDictionary *)resp errDict:nil doDelete:YES];
    }
}

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        [theApp addAppHandle:self];
        [BCApplePayUtil setBeeCloudDelegate:self];
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
    
    if (bcAppid.isValid) {
        [BCApplePayUtil initWithAppID:bcAppid];
    }
}

@end
