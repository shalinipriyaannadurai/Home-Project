//
//  DeviceListingCell.h
//  Home Project
//
//  Created by shruthi on 06/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightness;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;

@end
