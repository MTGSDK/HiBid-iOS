//
//  IndexViewPageViewController.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/16.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "IndexViewPageViewController.h"
#import "HBAdsBidRequest.h"

@interface IndexViewPageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;

@property (nonatomic,strong)  NSArray *networkItems;
@property (nonatomic,strong)  HBAuctionResult *auctionResult;
@property (nonatomic,strong)  NSError *auctionResultError;
@property (nonatomic,strong)  NSMutableArray *networkBidResponses;


@end

@implementation IndexViewPageViewController
- (IBAction)requestAuctionResultButtonAction:(id)sender {
    
    [self reqeustBids];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.networkItems = [self buildBidAdNetworkItems];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;

}

- (void)reqeustBids{
    
    self.bidButton.userInteractionEnabled = NO;
    self.auctionResultError = nil;
    self.auctionResult = nil;
    [self.networkBidResponses removeAllObjects];
    [self.tableView reloadData];

    NSString *unitId = @"IndexPageUnitID";
    [HBAdsBidRequest getBidNetworks:self.networkItems unitId:unitId adFormat:(HBAdBidFormatRewardedVideo) maxTimeoutMS:400 responseCallback:^(HBAuctionResult *auctionResponse,NSError *error) {
        if (error) {
            self.auctionResultError = error;
            self.auctionResult = nil;
        }else{
            self.auctionResultError = nil;
            self.auctionResult = auctionResponse;
            [self.networkBidResponses addObject:auctionResponse.winner];
            [self.networkBidResponses addObjectsFromArray:auctionResponse.otherResponse];
        }
        
        self.bidButton.userInteractionEnabled = YES;
        [self.tableView reloadData];
    }];
}

- (NSArray *)buildBidAdNetworkItems{

    NSMutableArray *items = [NSMutableArray new];

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
    NSString *mtg_appId = @"place your mtg appId here";
    NSString *mtg_apiKey = @"place your mtg apiKey here";
    NSString *mtg_unitId = @"placeyour mtg unitId here";

    NSValue *bannerSize = [NSValue valueWithCGSize:CGSizeMake(320,50)];//only banner required
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

    return items;
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.networkBidResponses.count == 0) {
        return 1;
    }

    return self.networkBidResponses.count + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    if (self.networkBidResponses.count == 0) {
        
        NSString *title = @"please click bid button to request bids";
        if (self.auctionResultError) {
            title = [NSString stringWithFormat:@"Bid response faile with error:%@",self.auctionResultError.description];
        }else if(!self.bidButton.userInteractionEnabled){
            title = @"please wait the response ...";
        }
        cell.textLabel.text = title;
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Here are current network bid responses:";
        }else if (indexPath.row == self.networkBidResponses.count + 1){
            HBAdBidResponse *winner = self.auctionResult.winner;
            cell.textLabel.text = [NSString stringWithFormat:@"The winner is:%@",[winner.networkItem getNetworkName]];
            cell.textLabel.textColor = UIColor.redColor;
        }else{
            HBAdBidResponse *response = [self.networkBidResponses objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [self buildLabelContentWithResponse:response];
        }
    }
    
    return cell;
}

- (NSString *)buildLabelContentWithResponse:(HBAdBidResponse *)response{
    
    NSString *networkName = [response.networkItem getNetworkName];
    
    NSString *networkResult = @"--";
    if (response.success) {
        networkResult = [NSString stringWithFormat:@"%@ price:%f",networkName,response.price];
    }else{
        networkResult = [NSString stringWithFormat:@"%@ error:%@",networkName,response.error.description];
    }

    return networkResult;
}



-(NSMutableArray *)networkBidResponses{
    if (_networkBidResponses) {
        return _networkBidResponses;
    }
    _networkBidResponses = [NSMutableArray new];
    return _networkBidResponses;
}

@end
