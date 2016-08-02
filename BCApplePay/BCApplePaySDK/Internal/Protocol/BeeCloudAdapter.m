//
//  BeeCloudAdapaterProtocol.m
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BeeCloudAdapter.h"
#import "BeeCloudAdapterProtocol.h"
#import "BCPayCache.h"

@implementation BeeCloudAdapter

+ (BOOL)beecloudCanMakeApplePayments:(NSUInteger)cardType {
    id adapter = [[NSClassFromString(kAdapterApplePay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(canMakeApplePayments:)]) {
        return [adapter canMakeApplePayments:cardType];
    }
    return NO;
}

+ (BOOL)beeCloudApplePay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterApplePay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(applePay:)]) {
        return [adapter applePay:dic];
    }
    return NO;
}

@end