//
//  DeviceListingCell.m
//  Home Project
//
//  Created by shruthi on 06/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DeviceListingCell.h"
#import "Client.h"

@implementation DeviceListingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    
    [_delegate switchDeviceState:_deviceId forDevBrightness:_brightness.text withSwitchState:_onOffSwitch.on];
   }
@end
