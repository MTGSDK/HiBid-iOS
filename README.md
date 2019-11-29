
# Documentation of HiBid open-source framework in iOS


## Overview

HiBid is an open source framework that aggregates multiple mainstream platforms that support head-bidding. Developers can quickly and efficiently implement head-bidding services of multiple platforms by using the HiBid open-source framework. Currently, the Network it already supports are Facebook and Mintegral.<br/>
This document describes how to integrate and integrate the HiBid framework on the iOS platform.


## How to use



### Start to bid(For example, Facebook && Mintegral)


1.Initialize the HBBidNetworkItem.

```objective

     NSString *fb_networkName = @"Facebook";
     NSString *fb_className = @"FBBidAdapter";
     NSString *fb_appID = @"place your fb appID here";
     NSString *fb_placementID = @"place your fb placementID here";
     NSNumber *fb_testMode = @(1);//testMode is true, @(0) means false
     NSNumber *fb_maxTimeoutMS = @(1000);//1000 ms

     NSDictionary *fbAdInfo = @{kHiBidCustomEventNetworkName:fb_networkName,
                                kHiBidCustomEventClassName:fb_className,
                                kHiBidCustomEventPlacementID:fb_placementID,
                                kHiBidCustomEventAppId:fb_appID,
                                kHiBidCustomEventeTestMode:fb_testMode,
                                kHiBidCustomEventeMaxTimeoutMS:fb_maxTimeoutMS
                                };
     HBBidNetworkItem *fbItem = [HBBidNetworkItem buildItemNetworkAdInfo:fbAdInfo];
     [items addObject:fbItem];

     NSString *mtg_networkName = @"Mintegral";
     NSString *mtg_className = @"MTGBidAdapter";
     NSString *mtg_appId  = @"place your mtg appId here";
     NSString *mtg_apiKey = @"place your mtg apiKey here";
     NSString *mtg_unitId = @"placeyour mtg unitId here";

     NSValue *bannerSize = [NSValue valueWithCGSize:CGSizeMake(320,50)];
     NSDictionary *extra = @{@"bannersize":bannerSize};
     NSDictionary *mtgAdInfo = @{kHiBidCustomEventNetworkName:mtg_networkName,
                                 kHiBidCustomEventClassName:mtg_className,
                                 kHiBidCustomEventAppId:mtg_appId,
                                 kHiBidCustomEventApiKey:mtg_apiKey,
                                 kHiBidCustomEventUnitId:mtg_unitId,
                                 kHiBidCustomEventeExtraKey:extra //only banner adType required
                                 };
     
     HBBidNetworkItem *mtgItem = [HBBidNetworkItem buildItemNetworkAdInfo:mtgAdInfo];
     [items addObject:mtgItem];
```

2.Call the method to get the bid response

```objective

     NSString *unitId = @"Your own unitId";
    [HBAdsBidRequest getBidNetworks:items unitId:unitId adFormat:(HBAdBidFormatRewardedVideo) maxTimeoutMS:4000 responseCallback:^(HBAuctionResult *auctionResponse,NSError *error) { ===
        if (error) {
            // to handle when error  ===
        }else{
            // success
            //auctionResponse.winner is the hightest price response   ===
        }
    }];

}
```


### Create a CustomAdapter(For example, Creating a Facebook Adapter)


1.Create a subclass of HBBidBaseCustomEvent in your project.（You can refer to the FBBidAdapter.m）<br/>
2.Override all the methods.<br/>


Sample code：

FBBidAdapter.h

```objective
#import "HBBidBaseCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBBidAdapter : HBBidBaseCustomEvent

@end

NS_ASSUME_NONNULL_END
```

FBBidAdapter.m

```objective
#import "FBBidAdapter.h"

#import <FBAudienceNetworkBiddingKit/FBAudienceNetworkBiddingKit.h>

NSString * const FBErrorDomain = @"com.facebook";

@implementation FBBidAdapter


-(void)dealloc{
    DLog(@"");
}

-(void)getBidNetwork:(HBBidNetworkItem *)networkItem adFormat:(HBAdBidFormat)format responseCallback:(void (^)(HBAdBidResponse * _Nonnull))callback{

    __block FBAdBidFormat currentAdFormat;
    NSError *error = nil;
    [self convertWithHBAdBidFormat:format result:^(FBAdBidFormat fbFormat, NSError *error) {
        currentAdFormat = fbFormat;
    }];
    if (error) {
        HBAdBidResponse *response = [HBAdBidResponse buildResponseWithError:error];
        callback(response);
        return;
    }

    if (networkItem.testMode) {

        [FBAdBidRequest getAudienceNetworkTestBidForAppID:networkItem.appId
                                              placementID:networkItem.unitId
                                               platformID:networkItem.platformId
                                                 adFormat:currentAdFormat
                                             maxTimeoutMS:networkItem.maxTimeoutMS
                                         responseCallback:^(FBAdBidResponse * _Nonnull bidResponse) {
        
        HBAdBidResponse *response = [self buildAdBidResponse:bidResponse networkItem:networkItem];
        callback(response);
    }];
    }else{
        [FBAdBidRequest getAudienceNetworkBidForAppID:networkItem.appId
                                          placementID:networkItem.unitId
                                           platformID:networkItem.platformId
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
        NSString *errorMsg = @"Current network still not support this adFormat";
        NSError *error = [HBAdBidError errorWithDomain:FBErrorDomain code:GDBidErrorNetworkBidFailed userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        response = [HBAdBidResponse buildResponseWithError:error];
        return response;
    }
    response = [HBAdBidResponse buildResponseWithPrice:bidResponse.getPrice currency:bidResponse.getCurrency payLoad:bidResponse.getPayload network: networkItem adsRender:nil notifyWin:^{
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
            error = [HBAdBidError errorWithDomain:FBErrorDomain code:GDBidErrorNetworkNotSupportCurrentAdFormat userInfo:@{NSLocalizedDescriptionKey : errorMsg}];

        }
            break;
    }

    callback(fbFormat,error);
}

@end
```




##FAQ
1.**What kinds of advertising formats are currently supported by HiBid?**<br/>
Currently，The ad types we supported: Native,Interstitial RewardVideo. But developers are allowed to customize other ad types.<br/>
2.**What currency is the price returned by the auction?**<br/>
The price returned by the auction is in US dollars. When the developer customizes the adapter, Make sure the price is in US dollars and it is not recommended to use other currencies and exchange rate conversions.<br/>
3.**How does it order the same bidder?**<br/>
If the Networks with the same prices, the one who returned first, is ranked first,and also is the winner.<br/>
4.**If the returned bid is 0, what does it mean?**<br/>
If the returned price is 0, so there is no winner in this auction.<br/>
5.**If there is a bidder failed, then the final response is success or fail?**<br/>
We have a 10S request-timeout. If one Network returns successfully in 10s, it will return success. And the price of other failed Networks is 0, and they will be in the other Networks' response list.

##changelog
Version | ChangeLog | Date
------|-----------|------
1.0.0 | HiBid released| 2019.05.13

