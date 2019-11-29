//
//  FBBidAdapter.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/10.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "FBBidAdapter.h"


#import <FBAudienceNetworkBiddingKit/FBAudienceNetworkBiddingKit.h>

NSString * const FBErrorDomain = @"com.facebook";

@implementation FBBidAdapter


-(void)dealloc{
    DLog(@"");
}

-(void)getBidNetwork:(HBBidNetworkItem *)networkItem adFormat:(HBAdBidFormat)format responseCallback:(void (^)(HBAdBidResponse * _Nonnull))callback{

    NSDictionary *adInfo = [networkItem getAdInfo];
    
    __block FBAdBidFormat currentAdFormat;
    NSError *error = nil;
    [self convertWithHBAdBidFormat:format result:^(FBAdBidFormat fbFormat, NSError *error) {
        currentAdFormat = fbFormat;
    }];
    if (error) {
        HBAdBidResponse *response = [HBAdBidResponse buildResponseWithError:error withNetwork:networkItem];
        callback(response);
        return;
    }

    BOOL testMode = [adInfo objectForKey:kHiBidCustomEventeTestMode]?[[adInfo objectForKey:kHiBidCustomEventeTestMode] boolValue]:NO;
    NSString *appId = [adInfo objectForKey:kHiBidCustomEventAppId];
    NSString *placementID = [adInfo objectForKey:kHiBidCustomEventPlacementID];
    NSString *platformId = [adInfo objectForKey:kHiBidCustomEventPlatformId];
    NSUInteger maxTimeoutMS = [adInfo objectForKey:kHiBidCustomEventeMaxTimeoutMS]?[[adInfo objectForKey:kHiBidCustomEventeMaxTimeoutMS] integerValue]:0;
    if (testMode) {

        [FBAdBidRequest getAudienceNetworkTestBidForAppID:appId
                                              placementID:placementID
                                               platformID:platformId
                                                 adFormat:currentAdFormat
                                             maxTimeoutMS:maxTimeoutMS
                                         responseCallback:^(FBAdBidResponse * _Nonnull bidResponse) {
        
        HBAdBidResponse *response = [self buildAdBidResponse:bidResponse networkItem:networkItem];
        callback(response);
    }];
    }else{
        [FBAdBidRequest getAudienceNetworkBidForAppID:appId
                                          placementID:placementID
                                           platformID:platformId
                                             adFormat:currentAdFormat
                                     responseCallback:^(FBAdBidResponse * _Nonnull bidResponse) {

            HBAdBidResponse *response = [self buildAdBidResponse:bidResponse networkItem:networkItem];
            callback(response);
        }];
    }
}

- (HBAdBidResponse *)buildAdBidResponse:(FBAdBidResponse *)bidResponse networkItem:(HBBidNetworkItem *)networkItem{
    HBAdBidResponse *response = nil;
    if (!bidResponse.isSuccess) {
        NSString *errorMsg = [bidResponse getErrorMessage];
        NSError *error = [HBAdBidError errorWithDomain:FBErrorDomain code:HBBidErrorNetworkBidFailed userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        response = [HBAdBidResponse buildResponseWithError:error withNetwork:networkItem];
        return response;
    }
    response = [HBAdBidResponse buildResponseWithPrice:bidResponse.getPrice currency:bidResponse.getCurrency payLoad:bidResponse.getPayload network:networkItem adsRender:nil notifyWin:^{
        [bidResponse notifyWin];
    } notifyLoss:^{
        [bidResponse notifyLoss];
    }];
    return response;
}

- (void)convertWithHBAdBidFormat:(HBAdBidFormat)format result:(void(^)(FBAdBidFormat fbFormat,NSError *error))callback{
    
    FBAdBidFormat fbFormat;
    NSError *error = nil;
    switch (format) {
        case HBAdBidFormatNative:
            fbFormat = FBAdBidFormatNative;
            break;
        case HBAdBidFormatInterstitial:
            fbFormat = FBAdBidFormatInterstitial;
            break;
        case HBAdBidFormatRewardedVideo:
            fbFormat = FBAdBidFormatRewardedVideo;
            break;
        default:
        {
            NSString *errorMsg = @"Current network still not support this adFormat";
            error = [HBAdBidError errorWithDomain:FBErrorDomain code:HBBidErrorNetworkNotSupportCurrentAdFormat userInfo:@{NSLocalizedDescriptionKey : errorMsg}];

        }
            break;
    }

    callback(fbFormat,error);
}

@end

