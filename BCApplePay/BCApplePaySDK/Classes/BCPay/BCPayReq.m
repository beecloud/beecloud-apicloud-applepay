//
//  BCPayReq.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCPayReq.h"
#import "BCPayUtil.h"
#import "BeeCloudAdapter.h"

#pragma mark pay request

@implementation BCPayReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = BCObjsTypePayReq;
        self.channel = @"";
        self.title = @"";
        self.totalFee = @"";
        self.billNo = @"";
        self.scheme = @"";
        self.viewController = nil;
        self.cardType = 0;
        self.billTimeOut = 0;
    }
    return self;
}

- (void)payReq {
    
    if (![self checkParametersForReqPay]) return;
    
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForPay];
    if (parameters == nil) {
        [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"请检查是否全局初始化"];
        return;
    }
    NSLog(@"bill_no %@", self.billNo);
  
    parameters[@"channel"] = self.channel;
    parameters[@"total_fee"] = [NSNumber numberWithInteger:[self.totalFee integerValue]];
    parameters[@"bill_no"] = self.billNo;
    parameters[@"title"] = self.title;
    
    if (self.billTimeOut > 0) {
        parameters[@"bill_timeout"] = @(self.billTimeOut);
    }
    
    if (self.optional) {
        parameters[@"optional"] = self.optional;
    }
    
    BCHTTPSessionManager *manager = [BCPayUtil getBCHTTPSessionManager];
    
    [manager POST:[BCPayUtil getBestHostWithFormat:kRestApiPay] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              NSDictionary *resp = (NSDictionary *)response;
              if ([[resp objectForKey:kKeyResponseResultCode] integerValue] != 0) {
                  if ([BCPay getBeeCloudDelegate] && [[BCPay getBeeCloudDelegate] respondsToSelector:@selector(onBeeCloudResp:)]) {
                      [[BCPay getBeeCloudDelegate] onBeeCloudResp:resp];
                  }
              } else {
                  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
                  [self doPayAction:dic];
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [BCPay doErrorResponse:kNetWorkError errDetail:kNetWorkError];
          }];
}

#pragma mark - Pay Action

- (void)doPayAction:(NSMutableDictionary *)dic {
    if (dic) {
        if ([self.channel isEqualToString:PayChannelApple]) {
            [dic setObject:self.viewController forKey:@"viewController"];
            [BeeCloudAdapter beeCloudApplePay:dic];
        }
    }
}

#pragma mark Util Function

- (BOOL)isValidChannel {
    if (!self.channel.isValid) {
        return NO;
    }
    NSArray *channelList = @[PayChannelApple];
    return [channelList containsObject:self.channel];
}

- (BOOL)checkParametersForReqPay {
    if (![self isValidChannel]) {
        [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"channel 渠道不支持"];
        return NO;
    } else if (!self.title.isValid || [BCPayUtil getBytes:self.title] > 32) {
        [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
        return NO;
    } else if (!self.totalFee.isValid || !self.totalFee.isPureInt) {
        [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"totalfee 以分为单位，必须是整数"];
        return NO;
    } else if (!self.billNo.isValidTraceNo || (self.billNo.length < 8) || (self.billNo.length > 32)) {
        [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
        return NO;
    } else if ([self.channel isEqualToString:PayChannelApple] && ![BeeCloudAdapter beecloudCanMakeApplePayments:self.cardType]) {
        switch (self.cardType) {
            case 0:
                [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"此设备不支持Apple Pay"];
                break;
            case 1:
                [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"不支持借记卡"];
                break;
            case 2:
                [BCPay doErrorResponse:kKeyCheckParamsFail errDetail:@"不支持信用卡"];
                break;
        }
        return NO;
    }
    return YES;
}

@end
