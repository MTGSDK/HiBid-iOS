//
//  HBBidNetworkItem.h
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdsBidConstants.h"


NS_ASSUME_NONNULL_BEGIN


@interface HBBidNetworkItem : NSObject


@property (nonatomic,copy,readonly) NSString *itemInstanceKey;


+ (HBBidNetworkItem *)buildItemNetworkAdInfo:(NSDictionary *)adInfo;

- (NSDictionary *)getAdInfo;
- (NSString *)getNetworkName;
- (NSString *)getCustomClassName;

@end

NS_ASSUME_NONNULL_END
