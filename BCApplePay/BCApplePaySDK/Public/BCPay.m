 //
//  BCPay.m
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCPay.h"

#import "BCPayUtil.h"
#import "BeeCloudAdapter.h"


@interface BCPay ()

@property (nonatomic, weak) id<BeeCloudDelegate> deleagte;

@end

@implementation BCPay

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCPay *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCPay alloc] init];
    });
    return instance;
}

+ (void)initWithAppID:(NSString *)appId {
    BCPayCache *instance = [BCPayCache sharedInstance];
    instance.appId = appId;
    [BCPay sharedInstance];
}

+ (void)setBeeCloudDelegate:(id<BeeCloudDelegate>)delegate {
    [BCPay sharedInstance].deleagte = delegate;
}

+ (id<BeeCloudDelegate>)getBeeCloudDelegate {
    return [BCPay sharedInstance].deleagte;
}

+ (NSString *)getBCApiVersion {
    return kApiVersion;
}

+ (BOOL)canMakeApplePayments:(NSUInteger)cardType {
    return [BeeCloudAdapter beecloudCanMakeApplePayments:cardType];
}

+ (void)setWillPrintLog:(BOOL)flag {
    [BCPayCache sharedInstance].willPrintLogMsg = flag;
}

+ (void)setNetworkTimeout:(NSTimeInterval)time {
    [BCPayCache sharedInstance].networkTimeout = time;
}

+ (void)sendBCReq:(BCBaseReq *)req {
    switch (req.type) {
        case BCObjsTypePayReq:
            [(BCPayReq *)req payReq];
            break;
        default:
            break;
    }
}

+ (void)doErrorResponse:(NSString *)resultMsg errDetail:(NSString *)errMsg {
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithCapacity:10];
    dic[kKeyResponseResultCode] = @(BCErrCodeCommon);
    dic[kKeyResponseResultMsg] = resultMsg;
    dic[kKeyResponseErrDetail] = errMsg;
    
    if ([BCPay getBeeCloudDelegate] && [[BCPay getBeeCloudDelegate] respondsToSelector:@selector(onBeeCloudResp:)]) {
        [[BCPay getBeeCloudDelegate] onBeeCloudResp:dic];
    }
}

@end
