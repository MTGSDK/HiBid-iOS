//
//  HBAdBidError.h
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/10.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const HBAdBidErrorDomain;

typedef enum {
    HBBidErrorUnknown = -1,
    HBBidErrorInputParamersInvalid = 10000,
    HBBidErrorNoValidResponse = 10001,
    HBBidErrorNetworkNotSupportCurrentAdFormat = 10002,
    HBBidErrorNetworkBidFailed = 10003,
    HBBidErrorNetworkBidTimeout = 10004,
    HBBidErrorNetworkPriceInvalid = 10005,
    HBBidErrorNetworkNotRespondToCurrentSDKVersion  = 10006

} HBBidErrorCode;

@interface HBAdBidError : NSObject

+ (NSError *)errorWithCode:(HBBidErrorCode)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;
+ (NSError *)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;

@end

NS_ASSUME_NONNULL_END
