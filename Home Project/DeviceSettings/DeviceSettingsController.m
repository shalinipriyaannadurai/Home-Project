//
//  DeviceSettingsController.m
//  Home Project
//
//  Created by shruthi on 06/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DeviceSettingsController.h"
#import "Client.h"
#import "HPDevice.h"

@interface DeviceSettingsController ()

@end

@implementation DeviceSettingsController

- (void)viewDidLoad {
    _deviceNameLabel.text=_device.name;
    _brightnessLabel.text=_brightness;
    _deviceId=_device.deviceId;
    _slider.value=[_brightness integerValue];
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateUpdated) name:@"DeviceUpdateNotification" object:nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)deviceStateUpdated
{
    _slider.value = _device.brightness;
    int progressAsInt =(int)(_slider.value);
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%d%%",progressAsInt];
    self.brightnessLabel.text=newText;

}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueChanged:(id)sender {
    NSString *request;
    UISlider *slider = (UISlider *) sender;
    int progressAsInt =(int)(slider.value);
    NSString *newText =[[NSString alloc]
                        initWithFormat:@"%d%%",progressAsInt];
    self.brightnessLabel.text=newText;
    _brightness=self.brightnessLabel.text ;
    request = @"on";

    _device.brightness=[_brightness integerValue];
    NSString *device = [NSString stringWithFormat:@"/api/v1/device/perform/%@",[_deviceId lastPathComponent]];
        NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %d}",[_brightness intValue]];
    [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
   
}
@end
