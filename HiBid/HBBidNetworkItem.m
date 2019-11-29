//
//  HBBidNetworkItem.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "HBBidNetworkItem.h"



NSString *const HBItemUniqueInstanceKey = @"HBItemUniqueInstanceKey";
@interface HBBidNetworkItem ()

@property (nonatomic,copy,readwrite) NSString *itemInstanceKey;
@property (nonatomic,strong)  NSDictionary *adInfo;
@end

@implementation HBBidNetworkItem

-(void)dealloc{
    DLog(@"");
}
#pragma mark  Private methods -

-(instancetype)initNetworkItem{
    self = [super init];
    if (self) {

        NSInteger instanceId = 0;
        @synchronized(HBItemUniqueInstanceKey) {
            static NSInteger __instance = 0;
            instanceId = __instance % (1024*1024);
            __instance++;
        }
        _itemInstanceKey = [NSString stringWithFormat:@"%ld", (long)instanceId];

    }
    return self;
}


#pragma mark  Public methods -

+ (HBBidNetworkItem *)buildItemNetworkAdInfo:(NSDictionary *)adInfo{
    
    HBBidNetworkItem *item = [[HBBidNetworkItem alloc] initNetworkItem];
    item.adInfo = adInfo;
    return item;

}

- (NSDictionary *)getAdInfo{
    return self.adInfo;
}

- (NSString *)getNetworkName{
    
    return [self.adInfo objectForKey:kHiBidCustomEventNetworkName];
}

- (NSString *)getCustomClassName{
    
    return [self.adInfo objectForKey:kHiBidCustomEventClassName];
}


@end
