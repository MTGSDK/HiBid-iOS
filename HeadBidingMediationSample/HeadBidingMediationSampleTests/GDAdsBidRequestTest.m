//
//  HBAdsBidRequestTest.m
//  HeadBidingMediationSampleTests
//
//  Created by CharkZhang on 2019/4/22.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HBAdsBidRequest.h"
#import "HBBidNetworkItem.h"

@interface HBAdsBidRequestTest : XCTestCase


@property (nonatomic,strong)  NSMutableArray *networkItems;

@end

@implementation HBAdsBidRequestTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSMutableArray *items = [NSMutableArray new];
    NSString *placementID = @"your fb placementID";
    NSString *appID = @"your fb appID";
    NSDictionary *adInfo = @{placementID:@"placementid",appID:@"appid"};
    HBBidNetworkItem *item = [HBBidNetworkItem buildItemNetworkAdInfo:adInfo];
    [items addObject:item];
    self.networkItems = items;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.networkItems removeAllObjects];
    self.networkItems = nil;

}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testRequestNetwork4RewardVideo{
    
    XCTAssertFalse(self.networkItems.count == 0);
    [HBAdsBidRequest getBidNetworks:self.networkItems unitId:@"My unit test unitId" adFormat:(HBAdBidFormatRewardedVideo) maxTimeoutMS:300 responseCallback:^(HBAuctionResult * _Nonnull auctionResponse, NSError * _Nonnull error) {
        // todo
    }];

}

- (void)testRequestNetwork4Native{
    
    XCTAssertFalse(self.networkItems.count == 0);
    [HBAdsBidRequest getBidNetworks:self.networkItems unitId:@"My unit test unitId" adFormat:(HBAdBidFormatNative) maxTimeoutMS:300 responseCallback:^(HBAuctionResult * _Nonnull auctionResponse, NSError * _Nonnull error) {
        // todo
    }];
    
}

- (void)testRequestNetwork4Interstitial{
    
    XCTAssertFalse(self.networkItems.count == 0);
    [HBAdsBidRequest getBidNetworks:self.networkItems unitId:@"My unit test unitId" adFormat:(HBAdBidFormatInterstitial) maxTimeoutMS:300 responseCallback:^(HBAuctionResult * _Nonnull auctionResponse, NSError * _Nonnull error) {
        // todo
    }];
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
