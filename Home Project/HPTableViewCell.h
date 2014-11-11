//
//  HPTableViewCell.h
//  Lightbulb
//
//  Created by SHALINI on 11/3/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface HPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *isDeviceSelected;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@end
