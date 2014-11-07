//
//  DeviceSettingsController.h
//  Home Project
//
//  Created by shruthi on 06/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPDevice.h"

@interface DeviceSettingsController : UIViewController
- (IBAction)backButtonClick:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (nonatomic,strong) HPBulb *device;
@property (nonatomic,strong) NSString *brightness;
@property (nonatomic,strong) NSString *deviceId;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
 //UILabel *brightnessLabel;

@end
