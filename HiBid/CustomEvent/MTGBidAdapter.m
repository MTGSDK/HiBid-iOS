//
//  MTGBidAdapter.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/10.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "MTGBidAdapter.h"
#import "MTGSDKBidding/MTGBiddingRequest.h"
#import "MTGSDKBidding/MTGBiddingBannerRequestParameter.h"

NSString * const MTGErrorDomain = @"com.mintegral";

@implementation MTGBidAdapter

-(void)dealloc{
    DLog(@"");
}

-(void)getBidNetwork:(HBBidNetworkItem *)networkItem adFormat:(HBAdBidFormat)format responseCallback:(void (^)(HBAdBidResponse * _Nonnull))callback{

    NSDictionary *adInfo = [networkItem getAdInfo];

    NSString *appId = [NSString stringWithFormat:@"%@",[adInfo objectForKey:kHiBidCustomEventAppId]];
    NSString *apiKey = [NSString stringWithFormat:@"%@",[adInfo objectForKey:kHiBidCustomEventApiKey]];
    NSString *unitId = [NSString stringWithFormat:@"%@",[adInfo objectForKey:kHiBidCustomEventUnitId]];

    if (appId.length == 0 || apiKey.length == 0 || unitId.length == 0) {

        NSString *errorMsg = @"Required input params for Mintegral is invalid";
        NSError *error = [HBAdBidError errorWithDomain:MTGErrorDomain code:HBBidErrorInputParamersInvalid userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        HBAdBidResponse *response = [HBAdBidResponse buildResponseWithError:error withNetwork:networkItem];
        callback(response);
        return;
    }

    [[MTGSDK sharedInstance] setAppID:appId ApiKey:apiKey];

    NSDictionary *extra = [adInfo objectForKey:kHiBidCustomEventeExtraKey];
    NSValue *bannerSize = [extra objectForKey:@"bannersize"];
    
    MTGBiddingRequestParameter *parameter = nil;
    if (bannerSize) {
            CGSize size = [bannerSize CGSizeValue];
        parameter = [[MTGBiddingBannerRequestParameter alloc]initWithUnitId:unitId basePrice:nil unitSize:size];
    }else{
        parameter = [[MTGBiddingRequestParameter alloc]initWithUnitId:unitId basePrice:nil];
    }

    [MTGBiddingRequest getBidWithRequestParameter:parameter completionHandler:^(MTGBiddingResponse * _Nonnull bidResponse) {
        HBAdBidResponse *response = [self buildAdBidResponse:bidResponse networkItem:networkItem];
        callback(response);
    }];
}

- (HBAdBidResponse *)buildAdBidResponse:(MTGBiddingResponse *)bidResponse networkItem:(HBBidNetworkItem *)networkItem{
    HBAdBidResponse *response = nil;
    if (!bidResponse.success) {
        NSString *errorMsg = bidResponse.error.debugDescription;
        NSError *error = [HBAdBidError errorWithDomain:MTGErrorDomain code:HBBidErrorNetworkBidFailed userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        response = [HBAdBidResponse buildResponseWithError:error withNetwork:networkItem];
        return response;
    }
    response = [HBAdBidResponse buildResponseWithPrice:bidResponse.price currency:bidResponse.currency payLoad:bidResponse.bidToken  network:networkItem adsRender:nil notifyWin:^{
        [bidResponse notifyWin];
    } notifyLoss:^{
        [bidResponse notifyLoss:(MTGBidLossedReasonCodeLowPrice)];
    }];
    return response;
}
@end
