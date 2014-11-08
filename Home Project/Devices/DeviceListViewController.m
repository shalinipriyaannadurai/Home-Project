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


@interface DeviceListViewController ()
@property(nonatomic,strong) HPBulb *lights;
@property(nonatomic,strong) HPVideo *videoDevices;
@property(nonatomic,strong) HPDevice *devices;
@end

@implementation DeviceListViewController

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
    if([_groupName isEqualToString: @"bulb"]){
        _lights=[_deviceDetailArray objectAtIndex:indexPath.row];
        _devices=_lights;
        listingCell.txtBrightness.text=[NSString stringWithFormat:@"%d%%", (int)_lights.brightness];
    }
   else if([_groupName isEqualToString: @"video"]){
   _videoDevices=[_deviceDetailArray objectAtIndex:indexPath.row];
       _devices=_videoDevices;
       listingCell.txtBrightness.hidden=TRUE;
       listingCell.deviceImage.hidden=TRUE;
       listingCell.onOffSwitch.hidden=TRUE;
    }

    if([_devices.status isEqualToString:@"on"]){
        
        [listingCell.onOffSwitch setOn:YES animated:YES];
        _devices.status=@"on";
    }
    else if([_devices.status isEqualToString:@"off"]){
            [listingCell.onOffSwitch setOn:NO animated:YES];
    }
   else{
       [listingCell.onOffSwitch setOn:YES animated:YES];
       _devices.status=@"off";
        }
    
    listingCell.deviceName.text=_devices.name;
    listingCell.descriptionLabel.text=_devices.deviceId;
    listingCell.deviceId=_devices.deviceId;
    
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
-(void)switchDeviceState: (NSString *) deviceIdForCell forDevBrightness:(NSString *)brightnessValue  withSwitchState:(BOOL)state{
    if(state){
         _devices.status=@"on";
         //_lights.brightness=100;
        
    }
    else{
        _devices.status=@"off";
       // _lights.brightness=0.0;
        
    }
   

    NSString *device = [NSString stringWithFormat:@"/api/v1/device/perform/%@",[deviceIdForCell lastPathComponent]];
    NSString *request = _devices.status;
    NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %d}",[brightnessValue intValue]];
    [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
    
}

@end
