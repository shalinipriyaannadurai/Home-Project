//
//  DeviceListViewController.h
//  Home Project
//
//  Created by shruthi on 03/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPDevice.h"
#import "DeviceListingCell.h"


@interface DeviceListViewController : UIViewController<deviceSwitchStateDelegate>

- (IBAction)backButtonClick:(id)sender;

@property (nonatomic,strong) NSMutableArray *deviceDetailArray;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *selectedDeviceId;
@property (nonatomic,strong) NSString *selectedDeviceName;
@property (nonatomic,strong) NSString *selectedBrightness;
@property (nonatomic,strong) id selectedDeviceGroup;
@property (weak, nonatomic) IBOutlet UILabel *titleString;
@property (weak, nonatomic) IBOutlet UITableView *deviceListingTable;

@end
