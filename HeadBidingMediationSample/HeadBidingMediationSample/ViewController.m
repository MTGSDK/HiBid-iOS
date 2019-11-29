//
//  ViewController.m
//  HeadBidingMediationSample
//
//  Created by CharkZhang on 2019/4/9.
//  Copyright © 2019 Mintegral. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "GDAdsBidRequest.h"
#import "GDAdBidResponse.h"

@interface ViewController ()

//@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  UIButton *bidButton;
@property (nonatomic,strong)  GDAdBidResponse *bidResponse;
@property (nonatomic,strong)  NSArray *networkItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    self.networkItems = [self buildBidAdNetworkItems];
    [self createBidButton];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
}

- (void)reqeustBids{
    
    self.bidButton.userInteractionEnabled = NO;

    NSString *unitId = @"IndexPageUnitID";
    [GDAdsBidRequest getBidNetworks:self.networkItems unitId:unitId adFormat:(GDAdBidFormatRewardedVideo) timeout:5 responseCallback:^(GDAuctionResult *auctionResponse,NSError *error) {

        self.bidResponse = auctionResponse.winner;
        [self.tableView reloadData];
        self.bidButton.userInteractionEnabled = YES;
    }];
}

- (NSArray *)buildBidAdNetworkItems{
    
    
    NSMutableArray *items = [NSMutableArray new];
    GDBidNetworkItem *item1 = [GDBidNetworkItem buildItemNetwork:(GDAdBidNetworkTEST1)
                                        customEventClassName:@"TEST1BidAdapter"
                                                       appId:@""
                                                      unitId:@""
                                                     timeout:9];
    [items addObject:item1];
    GDBidNetworkItem *item2 = [GDBidNetworkItem buildItemNetwork:(GDAdBidNetworkTEST2)
                                        customEventClassName:@"TEST2BidAdapter"
                                                       appId:@""
                                                      unitId:@""
                                                     timeout:9];
    [items addObject:item2];
    GDBidNetworkItem *item3 = [GDBidNetworkItem buildItemNetwork:(GDAdBidNetworkTEST3)
                                        customEventClassName:@"TEST3BidAdapter"
                                                       appId:@""
                                                      unitId:@""
                                                     timeout:9];
    [items addObject:item3];

    GDBidNetworkItem *item4 = [GDBidNetworkItem buildItemNetwork:(GDAdBidNetworkTEST3)
                                            customEventClassName:@"FBBidAdapter"
                                                           appId:@""
                                                          unitId:@""
                                                         timeout:9];
    [items addObject:item4];
    return items;
}

#pragma mark -

- (void)createBidButton{
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView *window = appDelegate.window;
    UIButton *bidButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bidButton setTitle:@"Bid" forState:(UIControlStateNormal)];
    [bidButton setTitle:@"Bid" forState:(UIControlStateHighlighted)];
    bidButton.backgroundColor = UIColor.grayColor;
//    [window addSubview:bidButton];
    bidButton.frame = CGRectMake((self.view.frame.size.width - 150) * 0.5, self.view.frame.size.height - 150, 150, 80);
    [self.view.superview addSubview:bidButton];
    
    
    return;
    /*
    [window bringSubviewToFront:bidButton];
    
    bidButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:bidButton
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:window
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.f constant:0];

    NSLayoutConstraint *horizon = [NSLayoutConstraint constraintWithItem:bidButton
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:window
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.f constant:50];
    [window addConstraint:centerX];
    [window addConstraint:horizon];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:bidButton
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:window
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:0.2
                                                                   constant:0];
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:bidButton
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:window
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:0.1
                                                                   constant:0];
    [window addConstraint:constraint_width];
    [window addConstraint:constraint_height];
    */
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.networkItems.count;

//    NSInteger count = 0;
//    if (!self.bidResponse) {
//        count = self.networkItems.count;
//    }else{
//        if (self.bidResponse.success) {
//            count = self.networkItems.count;
//            #warning  Chark TODO
//        }else{
//            count = 1;// bid failed
//        }
//    }
//    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    GDBidNetworkItem *item = [self.networkItems objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [self getNetworkNameFromItem:item];

//    if (!self.bidResponse) {
//        cell.textLabel.text = [self getNetworkNameFromItem:item];
//    }else{
//        GDAdBidResponse *networkResponse = nil;
//        if (self.bidResponse.success) {
//            //        networkResponse = self
//        }else{
//
//        }
//    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSString *)buildLabelContent:(GDBidNetworkItem *)item withResponse:(GDAdBidResponse *)response{
    
    NSString *networkName = [self getNetworkNameFromItem:item];
    
    
    return networkName;
}

- (NSString *)getNetworkNameFromItem:(GDBidNetworkItem *)item{
    
    NSString *networkName = [item.customEventClassName stringByReplacingOccurrencesOfString:@"BidAdapter" withString:@""];
    return networkName;
}
@end
