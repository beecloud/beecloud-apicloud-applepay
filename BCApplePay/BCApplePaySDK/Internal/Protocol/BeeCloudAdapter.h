//
//  BCProtocol.h
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPay.h"

@interface BeeCloudAdapter : NSObject

+ (BOOL)beeCloudApplePay:(NSMutableDictionary *)dic;
+ (BOOL)beecloudCanMakeApplePayments:(NSUInteger)cardType;

@end