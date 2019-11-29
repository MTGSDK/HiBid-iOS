//
//  HBBidBaseCustomEvent.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "HBBidBaseCustomEvent.h"

NSString *const kHiBidCustomEventNetworkName    = @"networkname";
NSString *const kHiBidCustomEventClassName      = @"classname";
NSString *const kHiBidCustomEventPlacementID    = @"placementid";
NSString *const kHiBidCustomEventUnitId         = @"unitid";
NSString *const kHiBidCustomEventPlatformId     = @"platformid";
NSString *const kHiBidCustomEventAppId          = @"appid";
NSString *const kHiBidCustomEventApiKey         = @"apikey";
NSString *const kHiBidCustomEventeMaxTimeoutMS  = @"timeout";
NSString *const kHiBidCustomEventeTestMode      = @"testmode";
NSString *const kHiBidCustomEventeExtraKey      = @"extra";



@implementation HBBidBaseCustomEvent

- (void)getBidNetwork:(HBBidNetworkItem *)networkItem adFormat:(HBAdBidFormat)format responseCallback:(void(^)(HBAdBidResponse *bidResponse))callback{
    
}


@end
