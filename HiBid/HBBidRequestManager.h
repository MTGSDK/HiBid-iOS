//
//  HBBidRequestManager.h
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdsBidConstants.h"
#import "HBAuctionResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBBidRequestManager : NSObject


- (void)getBidNetworks:(NSArray *)networkItems unitId:(NSString *)unitId adFormat:(HBAdBidFormat)format maxTimeoutMS:(NSInteger)maxTimeoutMS responseCallback:(void(^)(HBAuctionResult *auctionResponse,NSError *error))callback;




@end

NS_ASSUME_NONNULL_END
