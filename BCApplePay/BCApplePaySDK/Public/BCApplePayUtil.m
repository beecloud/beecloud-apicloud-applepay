 //
//  BCPay.m
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCApplePayUtil.h"
#import "BCUtil.h"


@interface BCApplePayUtil ()

@property (nonatomic, weak) id<BCApplePayDelegate> deleagte;

@end

@implementation BCApplePayUtil

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCApplePayUtil *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCApplePayUtil alloc] init];
    });
    return instance;
}

+ (void)initWithAppID:(NSString *)appId {
    BCApplePayCache *instance = [BCApplePayCache sharedInstance];
    instance.appId = appId;
}

+ (void)setBeeCloudDelegate:(id<BCApplePayDelegate>)delegate {
    [BCApplePayUtil sharedInstance].deleagte = delegate;
}

+ (id<BCApplePayDelegate>)getBeeCloudDelegate {
    return [BCApplePayUtil sharedInstance].deleagte;
}

+ (NSString *)getBCApiVersion {
    return kApiVersion;
}

+ (void)doErrorResponse:(NSString *)resultMsg errDetail:(NSString *)errMsg {
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithCapacity:10];
    dic[kKeyResponseResultCode] = @(BCErrCodeCommon);
    dic[kKeyResponseResultMsg] = resultMsg;
    dic[kKeyResponseErrDetail] = errMsg;
    
    if ([BCApplePayUtil getBeeCloudDelegate] && [[BCApplePayUtil getBeeCloudDelegate] respondsToSelector:@selector(onBCApplePayResp:)]) {
        [[BCApplePayUtil getBeeCloudDelegate] onBCApplePayResp:dic];
    }
}

@end
