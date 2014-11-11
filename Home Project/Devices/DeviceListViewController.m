//
//  DeviceListViewController.m
//  Home Project
//
//  Created by shruthi on 03/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DashBoardController.h"
#import "DeviceListingCell.h"
#import "HPDevice.h"
#import "DeviceSettingsController.h"
#import "Client.h"
#import <LIFXKit/LIFXKit.h>

@interface DeviceListViewController ()
@property(nonatomic,strong) HPBulb *lights;
@property(nonatomic,strong) HPVideo *videoDevices;
@property(nonatomic,strong) HPDevice *devices;
@end

@implementation DeviceListViewController
@synthesize deviceType = _deviceType;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateUpdated) name:@"DeviceUpdateNotification" object:nil];
    // Do any additional setup after loading the view.
    self.titleString.text = self.groupName;
    
}

-(void) viewWillAppear:(BOOL)animated{
    [_deviceListingTable reloadData];
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
    [self.deviceListingTable reloadData];
    
}



- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_deviceDetailArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"DeviceListingCell";
    DeviceListingCell *listingCell=(DeviceListingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (listingCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceListingCell" owner:self options:nil];
        listingCell = [nib objectAtIndex:0];
        listingCell.delegate=self;
    }
    
    listingCell.frame=CGRectMake(0, 0, self.view.frame.size.width, 80);
    listingCell.backgroundColor=[UIColor clearColor];
    listingCell.txtBrightness.hidden=FALSE;

    
    switch (_deviceType) {
        case eLights:
        {
            HPBulb *lightDevice = [_deviceDetailArray objectAtIndex:indexPath.row];
            listingCell.txtBrightness.text=[NSString stringWithFormat:@"%d%%", (int)[(HPBulb*)lightDevice brightness]];
            listingCell.deviceName.text=lightDevice.name;
            listingCell.descriptionLabel.text=lightDevice.deviceId;
            listingCell.deviceId=lightDevice.deviceId;
            [listingCell.onOffSwitch setOn:[lightDevice.status isEqualToString:@"on"] ? YES : NO animated:YES];

        }
            break;
        case eSecurity:
        {
            LFXLight *light = [_deviceDetailArray objectAtIndex:indexPath.row];
            listingCell.deviceName.text = @"LIFX Light";
            listingCell.descriptionLabel.text=@"Replacement for Lock";

            [listingCell.onOffSwitch setOn:light.powerState animated:YES];
            listingCell.txtBrightness.hidden=TRUE;
        }
            break;
        case eThermostat:
        {
            listingCell.txtBrightness.hidden=TRUE;
        }
            break;
        case eVideo:
        {
            HPVideo *videoDevice = [_deviceDetailArray objectAtIndex:indexPath.row];

            listingCell.txtBrightness.hidden=TRUE;
            listingCell.deviceImage.hidden=TRUE;
            listingCell.onOffSwitch.hidden=TRUE;
            listingCell.deviceName.text=videoDevice.name;
            listingCell.descriptionLabel.text=videoDevice.deviceId;
            listingCell.deviceId=videoDevice.deviceId;

        }
            break;
            
        default:
            break;
    }
    
    
    return listingCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceListingCell *selectedCell = (DeviceListingCell *)[tableView cellForRowAtIndexPath:indexPath];
    _selectedDeviceId=selectedCell.deviceId;
    _selectedDeviceName=selectedCell.deviceName.text;
    _selectedBrightness=selectedCell.txtBrightness.text;
    _selectedDeviceGroup=[_deviceDetailArray objectAtIndex:indexPath.row];
    if([_groupName isEqualToString: @"bulb"]){
        [self performSegueWithIdentifier:@"DeviceSettings" sender:self];
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DeviceSettings"]) {
        DeviceSettingsController *deviceSettings =[segue destinationViewController];
        
        deviceSettings.device=_selectedDeviceGroup;
        deviceSettings.brightness=_selectedBrightness;
        ///NSDictionary *bulbDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"blub1", nil]
    }
    
    
}
-(void)switchDeviceState: (NSString *) deviceId forDevBrightness:(NSString *)brightnessValue  withSwitchState:(BOOL)state{
    
    switch (_deviceType) {
        case eLights:
        {
            HPBulb *lightDevice = [self lightWithId:deviceId];
            
            if(state){
                lightDevice.status=@"on";
            }
            else{
                lightDevice.status=@"off";
            }
            NSString *device = [NSString stringWithFormat:@"/api/v1/device/perform/%@",[deviceId lastPathComponent]];
            NSString *request = lightDevice.status;
            NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %d}",[brightnessValue intValue]];
            [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
        }
            break;
        case eSecurity:
        {
            LFXLight *light = [_deviceDetailArray objectAtIndex:0];
            light.powerState = state;
            
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

            NSString *status = light.powerState? @"UnLocked" : @"Locked";
                                              
            NSString *date = @"2014-11-11 17:20:11";
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"/device/lighting/lifx/lock", @"whatami",@"lifx_bulb",@"whoami", @"Lock", @"name", status, @"status", date, @"updated",  nil];
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSString *path = @"Http://192.168.2.12:8080/machinelearning/event";
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            [request setTimeoutInterval:10];
            
            NSURLSessionDataTask *putDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response : %@", response);
                NSLog(@"Error : %@", error);
                
            }];
            [putDataTask resume];

        }
            break;
        case eThermostat:
        {
            
        }
            break;
        case eVideo:
        {
            
        }
            break;

        default:
            break;
    }
    
}

- (HPBulb *)lightWithId:(NSString *)inDeviceId
{
    NSMutableArray *bulbDevices = _deviceDetailArray;
    HPBulb *retBulb = nil;
    
    for (HPBulb *bulb in bulbDevices)
    {
        if ([bulb isDeviceWithId:inDeviceId])
        {
            retBulb = bulb;
        }
    }
    
    return retBulb;
}


@end
