//
//  DeviceListingCell.h
//  Home Project
//
//  Created by shruthi on 06/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol deviceSwitchStateDelegate <NSObject>

-(void) switchDeviceState: (NSString *)deviceId forDevBrightness:(NSString *)brightness withSwitchState:(BOOL )state;

@end

@interface DeviceListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightness;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (nonatomic,strong) NSString *deviceId;
@property(nonatomic,weak) id <deviceSwitchStateDelegate> delegate;
- (IBAction)switchValueChanged:(id)sender;

@end
