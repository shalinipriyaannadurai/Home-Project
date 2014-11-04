//
//  DeviceListViewController.h
//  Home Project
//
//  Created by shruthi on 03/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListViewController : UIViewController

- (IBAction)backButtonClick:(id)sender;

@property (nonatomic,strong) NSArray *deviceDetailArray;
@property (nonatomic,strong) NSString *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *titleString;

@end
