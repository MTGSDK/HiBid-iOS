//
//  HBAdsBidConstants.h
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#ifndef HBAdsBidConstants_h
#define HBAdsBidConstants_h

#define HiBidVersion  @"1.0.0"

typedef NS_ENUM(NSInteger, HBAdBidFormat) {
    // Bid For Native Ad
    HBAdBidFormatNative = 1,
    // Bid For Interstitial Ad
    HBAdBidFormatInterstitial,
    // Bid For Rewarded Video Ad
    HBAdBidFormatRewardedVideo,
};


extern NSString *const kHiBidCustomEventNetworkName;
extern NSString *const kHiBidCustomEventClassName;
extern NSString *const kHiBidCustomEventPlacementID;
extern NSString *const kHiBidCustomEventUnitId;
extern NSString *const kHiBidCustomEventPlatformId;
extern NSString *const kHiBidCustomEventAppId;
extern NSString *const kHiBidCustomEventApiKey;
extern NSString *const kHiBidCustomEventeMaxTimeoutMS;
extern NSString *const kHiBidCustomEventeTestMode;
extern NSString *const kHiBidCustomEventeExtraKey;




#ifdef DEBUG
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define DLog(fmt, ...)
#endif


#endif /* HBAdsBidConstants_h */
