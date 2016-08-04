//
//  BCCache.m
//  BeeCloud SDK
//
//  Created by Junxian Huang on 2/27/14.
//  Copyright (c) 2014 BeeCloud Inc. All rights reserved.
//

#import "BCApplePayCache.h"

#import "BCApplePayConstant.h"

@implementation BCApplePayCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCApplePayCache *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCApplePayCache alloc] init];
        
        instance.appId = nil;
        instance.sandbox = NO;
        
        instance.networkTimeout = 5.0;
        instance.willPrintLogMsg = NO;
        
    });
    return instance;
}

@end
