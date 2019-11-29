//
//  HBAdBidError.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/10.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "HBAdBidError.h"

NSString * const HBAdBidErrorDomain = @"com.hibid";

@implementation HBAdBidError

+ (NSError *)errorWithCode:(HBBidErrorCode)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict{
    
    NSError *error = [NSError errorWithDomain:HBAdBidErrorDomain code:code userInfo:dict];
    return error;
}

+ (NSError *)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict{
    
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:dict];
    return error;
}

@end
