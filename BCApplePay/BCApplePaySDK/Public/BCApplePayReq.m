//
//  BCPayReq.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCApplePayReq.h"
#import "BCApplePayUtil.h"

#pragma mark pay request

@implementation BCApplePayReq

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCApplePayReq *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCApplePayReq alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.totalFee = @"";
        self.billNo = @"";
        self.viewController = nil;
        self.cardType = 0;
        self.billTimeOut = 0;
    }
    return self;
}

- (void)applePayReq {
    
    if (![self checkParametersForReqPay]) return;
    
    NSMutableDictionary *parameters = [BCUtil prepareParametersForPay];
    if (parameters == nil) {
        [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"请检查是否全局初始化"];
        return;
    }
  
    parameters[@"channel"] = @"APPLE";
    parameters[@"total_fee"] = [NSNumber numberWithInteger:[self.totalFee integerValue]];
    parameters[@"bill_no"] = self.billNo;
    parameters[@"title"] = self.title;
    
    if (self.billTimeOut > 0) {
        parameters[@"bill_timeout"] = @(self.billTimeOut);
    }
    
    if (self.optional) {
        parameters[@"optional"] = self.optional;
    }
    
    BCAPHTTPSessionManager *manager = [BCUtil getBCAPHTTPSessionManager];
    
    [manager POST:[BCUtil getBestHostWithFormat:kRestApiPay] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              NSDictionary *resp = (NSDictionary *)response;
              if ([[resp objectForKey:kKeyResponseResultCode] integerValue] != 0) {
                  if ([BCApplePayUtil getBeeCloudDelegate] && [[BCApplePayUtil getBeeCloudDelegate] respondsToSelector:@selector(onBCApplePayResp:)]) {
                      [[BCApplePayUtil getBeeCloudDelegate] onBCApplePayResp:resp];
                  }
              } else {
                  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
                  [self applePay:dic];
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [BCApplePayUtil doErrorResponse:kNetWorkError errDetail:kNetWorkError];
          }];
}

#pragma mark Util Function

- (BOOL)checkParametersForReqPay {
    if (!self.title.isValid || [BCUtil getBytes:self.title] > 32) {
        [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
        return NO;
    } else if (!self.totalFee.isValid || !self.totalFee.isPureInt) {
        [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"totalfee 以分为单位，必须是整数"];
        return NO;
    } else if (!self.billNo.isValidTraceNo || (self.billNo.length < 8) || (self.billNo.length > 32)) {
        [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
        return NO;
    } else if (![self canMakeApplePayments]) {
        switch (self.cardType) {
            case 0:
                [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"此设备不支持Apple Pay"];
                break;
            case 1:
                [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"不支持借记卡"];
                break;
            case 2:
                [BCApplePayUtil doErrorResponse:kKeyCheckParamsFail errDetail:@"不支持信用卡"];
                break;
        }
        return NO;
    }
    return YES;
}

- (BOOL)applePay:(NSMutableDictionary *)dic {
    if ([self canMakeApplePayments]) {
        NSString *tn = [dic stringValueForKey:@"tn" defaultValue:@""];
        NSLog(@"apple tn = %@", dic);
        if (tn.isValid) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UPAPayPlugin startPay:tn mode:@"00" viewController:self.viewController delegate:self andAPMechantID:dic[@"apple_mer_id"]];
            });
            return YES;
        }
    }
    return NO;
}

#pragma mark - Implementation ApplePayDelegate

- (void)UPAPayPluginResult:(UPPayResult *)payResult {
    int errcode = BCErrCodeFail;
    NSString *strMsg = @"支付失败";
    
    switch (payResult.paymentResultStatus) {
        case UPPaymentResultStatusSuccess: {
            strMsg = @"支付成功";
            errcode = BCSuccess;
            break;
        }
        case UPPaymentResultStatusFailure:
            break;
        case UPPaymentResultStatusCancel: {
            strMsg = @"支付取消";
            break;
        }
        case UPPaymentResultStatusUnknownCancel: {
            strMsg = @"支付取消,交易已发起,状态不确定,商户需查询商户后台确认支付状态";
            break;
        }
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithCapacity:10];
    dic[kKeyResponseResultCode] = @(errcode);
    dic[kKeyResponseResultMsg] = strMsg;
    dic[kKeyResponseErrDetail] = payResult.errorDescription.isValid ? payResult.errorDescription : strMsg;
    
    if ([BCApplePayUtil getBeeCloudDelegate] && [[BCApplePayUtil getBeeCloudDelegate] respondsToSelector:@selector(onBCApplePayResp:)]) {
        [[BCApplePayUtil getBeeCloudDelegate] onBCApplePayResp:dic];
    }
}


- (BOOL)canMakeApplePayments {
    BOOL status = NO;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version <= 9.2f) return status;
    switch(self.cardType) {
        case 0:
        {
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]] ;
            break;
        }
        case 1:
        {
            PKMerchantCapability merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityDebit;
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay] capabilities:merchantCapabilities];
            break;
        }
        case 2:
        {
            PKMerchantCapability merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit;
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay] capabilities:merchantCapabilities];
            break;
        }
        default:
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]];
            break;
    }
    return status;
}

@end
