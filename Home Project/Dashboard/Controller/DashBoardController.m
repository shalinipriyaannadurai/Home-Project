//
//  DashBoardController_iPad.m
//  Home Project
//
//  Created by Shalini Priya A on 14/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DashBoardController.h"
#import "ElementCell.h"
#import "TotalElementCell.h"
#import "ProfileViewController.h"
#import "Utility.h"
#import "DeviceListViewController.h"
#import "NetworkManager.h"
#import "HPDevice.h"
#import <LIFXKit/LIFXKit.h>


@interface DashBoardController ()<LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver>

@property (nonatomic) LFXNetworkContext *lifxNetworkContext;

@property (nonatomic) NSArray *lights;

@property (nonatomic) LFXLight *light;


@property (nonatomic,retain)  UITableView *frequentDevices;
@property (nonatomic,retain) IBOutlet UITableView *allDevices;
@property (nonatomic,retain) NSMutableArray *groupList;
@property(nonatomic,strong) NSString *title;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (nonatomic,retain) NSArray *frequentDevicesArray;
@property (nonatomic,retain) NSArray *allDevicesArray;
@property (nonatomic,retain)  DeviceListViewController *deviceListViewController;
//@property(nonatomic,strong) HPBulb  *bulb;
//@property(nonatomic,strong) HPVideo  *video;
@end

@implementation DashBoardController
@synthesize deviceList,frequentDevices,allDevices,indicator,subView,groupList; //,bulb,video;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
        [self.lifxNetworkContext addNetworkContextObserver:self];
        [self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [indicator startAnimating];
    
    
    if([[Utility sharedInstance] isIpad]){
        frequentDevices  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100)];
    }
    else {
        frequentDevices  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 70)];
    }
    [frequentDevices setBackgroundColor:[UIColor clearColor]];
    frequentDevices.separatorStyle =UITableViewCellSeparatorStyleNone;
    frequentDevices.transform = CGAffineTransformMakeRotation(M_PI/-2);
    frequentDevices.showsVerticalScrollIndicator = NO;
    
    if([[Utility sharedInstance] isIpad]){
        frequentDevices.frame = CGRectMake(0, 60, 1024, 100);
        [subView addSubview:frequentDevices];
    }
    else {
        frequentDevices.frame = CGRectMake(0, 32,  self.view.frame.size.width, 70);
    }
    
    frequentDevices.delegate = self;
    frequentDevices.dataSource = self;
    frequentDevices.tag=1;
    
    
    //    [allDevices setBackgroundColor:[UIColor clearColor]];
    //    allDevices.delegate = self;
    //    allDevices.dataSource = self;
    //    allDevices.tag=2;
    [self.view addSubview:indicator];
    
    Client *client = [Client sharedClient];
    client.delegate=self;
    deviceList=[NSMutableDictionary dictionary ];
    [client findSteward];
    [client startMonitoringEvents];
    [subView addSubview:frequentDevices];
    //[subView addSubview:allDevices];
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    //    [self getFrequentDevices];
    //    [self getAllConnectedDevices];
    
    self.allDevices.hidden = YES;
    self.frequentDevices.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateUpdated) name:@"DeviceUpdateNotification" object:nil];
}


- (void)deviceStateUpdated
{
    [self.allDevices reloadData];
    
}


-(void) getAllConnectedDevices{
    NetworkManager *manager=[[NetworkManager alloc] init];
    [manager getServerResponseFromURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] withHandler:^(NSArray *responseArray, NSError * error) {
        
        if(!error){
            self.allDevicesArray=responseArray;
        }
        else{
            NSLog(@"Error in response %@",error);
        }
    }];
}
-(void)getFrequentDevices{
    NetworkManager *manager=[[NetworkManager alloc] init];
    [manager getServerResponseFromURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] withHandler:^(NSArray *responseArray, NSError * error) {
        if(!error){
            self.frequentDevicesArray=responseArray;
        }
        else{
            NSLog(@"Error in response %@",error);
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [allDevices reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if ([deviceList count]<1) {
    //        return 1;
    //    }
    if(tableView.tag==1)
    return [deviceList count];
    else
    //return [groupList count];
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
        NSString *CellIdentifier = @"";
        
        ElementCell *cell;
        
        
        if([[Utility sharedInstance] isIpad]){
            // ElementCell *cell;
            CellIdentifier =  @"ElementCell_iPad";
            cell = (ElementCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ElementCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.frame=CGRectMake(0, 0, 1024, 100);
        }
        else {
            // ElementCell_iPhone *cell;
            CellIdentifier = @"ElementCell_iPhone";
            cell = (ElementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ElementCell_iPhone" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.frame=CGRectMake(0, 0, 320, 70);
        }
        
        
        
        
        
        
        
        cell.transform= CGAffineTransformMakeRotation(M_PI/2);
        [cell setBackgroundColor:[UIColor clearColor]];
        if ([deviceList count]>=1) {
            cell.elementTitle.text=[[[deviceList allKeys] objectAtIndex:indexPath.row]lastPathComponent];
            cell.elementDescription.text=@"This is description";
            cell.elementSubDescription.text=@"This is subdescription";
            [cell.elementImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",[cell.elementTitle.text lowercaseString]]]];
            if([cell.elementTitle.text isEqualToString:@"hue"]){
                cell.elementDescription.text=@"glowing";
                [cell.statusButton setTitle:@"ON" forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor redColor]];
                
            }
            if([cell.elementTitle.text isEqualToString:@"thermostat"]){
                cell.elementDescription.text=@"thermostat is idle";
                [cell.statusButton setTitle:@"OFF" forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor redColor]];
            }
            if([cell.elementTitle.text isEqualToString:@"lifx"]){
                cell.elementDescription.text=@"glowing";
                [cell.statusButton setTitle:@"OFF" forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor redColor]];
                
            }
            if([cell.elementTitle.text isEqualToString:@"door"]){
                cell.elementDescription.text=@"The door is locked";
                [cell.statusButton setTitle:@"OPEN" forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor redColor]];
            }
            if([cell.elementTitle.text isEqualToString:@"chromecast"]){
                cell.elementDescription.text=@"The video is paused";
                cell.elementDescription.textColor=[UIColor redColor];
                [cell.statusButton setBackgroundColor:[UIColor greenColor]];
                [cell.statusButton setTitle:@"PLAY" forState:UIControlStateNormal];
            }
            
        }
        return cell;
    }
    if(tableView.tag==2){
        static NSString *CellIdentifier = @"TotalCell";
        TotalElementCell *cell = (TotalElementCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        switch (indexPath.row) {
            case 0:
            {
                NSArray *list=[deviceList valueForKey:@"bulb"];
                
                
                NSString *groupName = @"Lights";
                cell.elementTitle.text= groupName;
                
                [cell.groupIcon setImage:[UIImage imageNamed:@"bulb_icon.png"]];
                cell.numLabel.text=[NSString stringWithFormat:@""];
                cell.elementDescription.text=[NSString stringWithFormat:@"No bulbs are connected."] ;
                cell.cellOverlayImageView.hidden = NO;
                cell.elementDescription.textColor=[UIColor redColor];
                [cell.numIcon setHidden:YES];
                [cell.numLabel setHidden:YES];
                
                if ([list count]>0) {
                    [cell.numIcon setHidden:NO];
                    [cell.numLabel setHidden:NO];
                    
                    cell.elementDescription.textColor=[UIColor greenColor];
                    cell.cellOverlayImageView.hidden = YES;
                    cell.numLabel.text=[NSString stringWithFormat:@"%d" ,[list count]];
                    cell.elementDescription.text=[NSString stringWithFormat:@"%d bulbs are connected." ,[list count]] ;
                    
                }
                
            }
            break;
            case 1:
            {
                
                cell.elementTitle.text= @"Security";
                [cell.numIcon setHidden:YES];
                [cell.numLabel setHidden:YES];
                cell.on_offIcon.hidden = YES;
                cell.elementDescription.text=@"No lock devices found.";
                [cell.groupIcon setImage:[UIImage imageNamed:@"door_icon.png"]];
                cell.elementDescription.textColor=[UIColor redColor];
                cell.cellOverlayImageView.hidden = NO;
                
                if(_light)
                {
                    [cell.numIcon setHidden:NO];
                    [cell.numLabel setHidden:NO];
                    cell.numLabel.text=[NSString stringWithFormat:@"1"];
                    cell.elementDescription.text=@"LIFX Light Found";
                    cell.elementDescription.textColor=[UIColor greenColor];
                    
                    cell.cellOverlayImageView.hidden = YES;
                }
                //[cell1.on_offIcon setImage:[UIImage imageNamed:@"off_icon.png"]];
                
            }
            break;
            case 2:
            {
                cell.elementTitle.text= @"Thermostat";
                [cell.numIcon setHidden:YES];
                [cell.numLabel setHidden:YES];
                cell.on_offIcon.hidden = YES;
                cell.elementDescription.text=@"No thermostat devices found.";
                [cell.groupIcon setImage:[UIImage imageNamed:@"thermostat_icon.png"]];
                cell.elementDescription.textColor=[UIColor redColor];
                cell.cellOverlayImageView.hidden = NO;
            }
            break;
            case 3:
            {
                NSArray *list=[deviceList valueForKey:@"video"];
                
                cell.elementTitle.text = @"Video";
                [cell.groupIcon setImage:[UIImage imageNamed:@"video_icon.png"]];
                [cell.numIcon setHidden:YES];
                [cell.numLabel setHidden:YES];
                
                if ([list count]>0) {
                    [cell.numIcon setHidden:NO];
                    [cell.numLabel setHidden:NO];
                    
                    [cell.on_offIcon setImage:[UIImage imageNamed:@"off_icon.png"]];
                    cell.elementDescription.text=@"The video is paused.";
                    cell.elementDescription.textColor=[UIColor redColor];
                    cell.cellOverlayImageView.hidden = YES;
                }
                else {
                    [cell.numIcon removeFromSuperview];
                    [cell.numLabel removeFromSuperview];
                    cell.on_offIcon.hidden = YES;
                    cell.elementDescription.text=@"No media devices found.";
                    cell.elementDescription.textColor=[UIColor redColor];
                    cell.cellOverlayImageView.hidden = NO;
                }
            }
            break;
            
            default:
            break;
        }
        
        
        
        
        return cell;
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%ld",(long)indexPath.row);
    NSString *storyboardString = nil;
    TotalElementCell *selectedCell = (TotalElementCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(![[Utility sharedInstance] isIpad] &&  tableView.tag==2){
        
        NSLog(@"%@",self.navigationController);
        // [self.navigationController pushViewController:svc animated:YES];
        switch (indexPath.row)
        {
            case 0:
            {
                self.title = @"bulb";
                
            }
            break;
            case 1:
            {
                self.title = @"security";
            }
            break;
            case 2:
            {
                self.title = @"thermostat";
            }
            break;
            case 3:
            {
                self.title = @"video";
                
            }
            break;
            
            default:
            break;
        }
        
        [self performSegueWithIdentifier:@"showDeviceList" sender:self];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES]
        //        if ((indexPath.row==3) || (indexPath.row == 2)) {
        //            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //        }
        //        else
        //        if([selectedCell.elementTitle.text isEqualToString:@"video"]){
        //            if ([groupList count]>=1) {
        //                NSString *groupName = (indexPath.row < groupList.count)?[groupList objectAtIndex:indexPath.row]:@"";
        //                NSArray *list=[deviceList valueForKey:groupName];
        //
        //
        //            if ([list count]<=0) {
        //                [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //              }
        //
        //            else {
        //                [self performSegueWithIdentifier:@"showDeviceList" sender:self];
        //            }
        //
        //
        //            }
        //        }
        //        else {
        //                [self performSegueWithIdentifier:@"showDeviceList" sender:self];
        //        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==1){
        if ([[Utility sharedInstance] isIpad]) {
            return 512;
        }
        else {
            return self.view.frame.size.width;
        }
    }
    else if ([[Utility sharedInstance] isIpad]) {
        return 150;
    }
    else{
        return 89;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView.tag==2) {
        return self.tableHeaderView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(tableView.tag==2) {
        return self.tableHeaderView.frame.size.height;
    }
    return 0.0;
}

-(void)viewDidLayoutSubviews
{
    if ([allDevices respondsToSelector:@selector(setSeparatorInset:)]) {
        [allDevices setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([allDevices respondsToSelector:@selector(setLayoutMargins:)]) {
        [allDevices setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([frequentDevices respondsToSelector:@selector(setSeparatorInset:)]) {
        [frequentDevices setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([frequentDevices respondsToSelector:@selector(setLayoutMargins:)]) {
        [frequentDevices setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showDeviceList"]) {
        
        DeviceListViewController *deviceListViewController =[segue destinationViewController];
        deviceListViewController.groupName= self.title;
        
        if([self.title isEqualToString:@"bulb"])
        {
            deviceListViewController.deviceDetailArray=[deviceList valueForKey:self.title];
            deviceListViewController.deviceType = eLights;
        }
        else if ([self.title isEqualToString:@"video"])
        {
            deviceListViewController.deviceDetailArray=[deviceList valueForKey:self.title];
            deviceListViewController.deviceType = eVideo;
        }
        else if ([self.title isEqualToString:@"security"])
        {
            //            HPDevice *device = [[HPDevice  alloc] init];
            //            device.name = @"LFX Light";
            //            device.status = _light.powerState? @"on" :@"off";
            deviceListViewController.deviceDetailArray=[NSMutableArray arrayWithObject:_light];
            deviceListViewController.deviceType = eSecurity;
        }
        ///NSDictionary *bulbDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"blub1", nil]
    }
    
    
}


#pragma mark - Client Delegate Methods

- (void)stewardFoundWithAddress:(NSString *)ipAddress {
    NSLog(@"stewardFoundWithAddress: %@", ipAddress);
    [[Client sharedClient] setDelegate:self];
    [[Client sharedClient] availableDevices];
    
    
}

- (void)stewardNotFoundWithError:(NSError *)error {
    NSLog(@"stewardNotFoundWithError: %@", error);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Steward Not found" message:[NSString stringWithFormat:@"Status :   %@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
}


-(void)recievedPerformResponse:(NSString *)message {
    NSLog(@"json = %@", message);
    
}
-(void)receivedDeviceList:(NSString *)message{
    
    NSDictionary *json =
    [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    NSMutableDictionary *jsonResult=[NSMutableDictionary dictionary];
    for (NSString *key in [[json valueForKey:@"result"] allKeys]) {
        if ([key hasPrefix:@"/device/"]==YES && [key hasPrefix:@"/device/gateway/"]==NO ) {
            NSMutableDictionary *deviceArray=[[json valueForKey:@"result"] valueForKey:key];
            if ([jsonResult valueForKey:[key lastPathComponent]]!=nil) {
                [deviceArray addEntriesFromDictionary:[jsonResult valueForKey:[key lastPathComponent]]];
            }
            [jsonResult setObject:deviceArray forKey:[key lastPathComponent]];
        }
    }
    NSLog(@"device list = %@", jsonResult);
    
    //    if (![deviceList valueForKey:@"bulb"])
    //    {
    [deviceList setObject:[NSMutableArray array] forKey:@"bulb"];
    [deviceList setObject:[NSMutableArray array] forKey:@"video"];
    
    //    }
    for (NSString *key in [jsonResult allKeys]) {
        if ([key isEqualToString:@"bulb"]==YES) {
            for (NSString *deviceId in [[jsonResult valueForKey:@"bulb"] allKeys]){
                NSDictionary *jsonBulb=[[jsonResult valueForKey:@"bulb"] valueForKey:deviceId];
                HPBulb *bulb=[[HPBulb alloc]initWithData:jsonBulb];
                bulb.deviceId = [deviceId lastPathComponent];
                [[deviceList valueForKey:@"bulb"] addObject:bulb];
            }
        }
        if ([key isEqualToString:@"video"]==YES) {
            for (NSString *deviceId in [[jsonResult valueForKey:@"video"] allKeys]){
                NSDictionary *jsonVideo=[[jsonResult valueForKey:@"video"] valueForKey:deviceId];
                HPVideo *video=[[HPVideo alloc]initWithData:jsonVideo];
                video.deviceId=[deviceId lastPathComponent];;
                [[deviceList valueForKey:@"video"] addObject:video];
            }
        }
        
    }
    groupList= (NSMutableArray*)[deviceList allKeys];
    
    [subView addSubview:frequentDevices];
    [subView addSubview:allDevices];
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];
    self.frequentDevices.hidden = NO;
    self.allDevices.hidden = NO;
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    
}
-(void)receivedEventMessage:(NSString *)message{
    NSDictionary *json =
    [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    if ([json valueForKey:@".updates"]!=nil && [[json valueForKey:@".updates"] count]!=0) {
        for (NSDictionary *keyValue in [json valueForKey:@".updates"]) {
            if ([keyValue valueForKey:@"whatami"]!=nil && [keyValue valueForKey:@"whoami"]!=nil) {
                NSString *group=[keyValue valueForKey:@"whatami"];
                if ([group hasPrefix:@"/device/"]==YES && [group hasPrefix:@"/device/gateway/"]==NO ) {
                    if ([[group lastPathComponent] isEqualToString:@"bulb"]==YES) {
                        NSString *deviceId = [[keyValue valueForKey:@"whoami"] stringByReplacingOccurrencesOfString:@"device/" withString:@""];
                        
                        HPBulb *bulbDevice = [self lightWithId:deviceId];
                        if(!bulbDevice)
                        {
                            
                            bulbDevice=[[HPBulb alloc]initWithData:keyValue];
                            bulbDevice.deviceId=[[keyValue valueForKey:@"whoami"] stringByReplacingOccurrencesOfString:@"device/" withString:@""];
                            [[deviceList valueForKey:@"bulb"] addObject:bulbDevice];
                        }
                        else
                        {
                            if ([bulbDevice.status isEqualToString:@"waiting"]) {
                                [[deviceList valueForKey:@"bulb"] removeObject:bulbDevice];
                            }
                            else
                            {
                                [bulbDevice updateLightWithData:keyValue];
                            }
                        }
                        
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceUpdateNotification" object:nil];
                    }
                    else if ([[group lastPathComponent] isEqualToString:@"video"]==YES) {
                        [deviceList setObject:[NSMutableArray array] forKey:@"video"];
                        
                        NSString *deviceId = [[keyValue valueForKey:@"whoami"] lastPathComponent];
                        HPVideo *mediaDevice = [self mediaDeviceWithId:deviceId];
                        
                        if(!mediaDevice)
                        {
                            mediaDevice = [[HPVideo alloc]initWithData:keyValue];
                            mediaDevice.deviceId=[deviceId lastPathComponent];
                            [[deviceList valueForKey:@"video"] addObject:mediaDevice];
                            
                        }
                        [[deviceList valueForKey:@"video"] addObject:mediaDevice];
                    }
                }
            }
        }
    }
    groupList=(NSMutableArray*)[deviceList allKeys];
}

- (HPBulb *)lightWithId:(NSString *)inDeviceId
{
    NSMutableArray *bulbDevices = [deviceList valueForKey:@"bulb"];
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

- (HPVideo *)mediaDeviceWithId:(NSString *)inDeviceId
{
    NSMutableArray *mediaDevices = [deviceList valueForKey:@"video"];
    HPVideo *retMediaDevice = nil;
    
    for (HPVideo *mediaDevice in mediaDevices)
    {
        if ([mediaDevice isDeviceWithId:inDeviceId])
        {
            retMediaDevice = mediaDevice;
        }
    }
    
    return retMediaDevice;
}


- (IBAction)userTapped:(id)sender {
    ProfileViewController *userProfile=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    [self presentViewController:userProfile animated:YES completion:nil];
}

- (IBAction)rulesTapped:(id)sender {
}



#pragma mark - LFXNetworkContextObserver

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
    NSLog(@"Network Context Did Connect");
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
    NSLog(@"Network Context Did Disconnect");
}

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
    NSLog(@"Network Context Did Add Tagged Light Collection: %@", collection.tag);
    [collection addLightCollectionObserver:self];
}

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
    NSLog(@"Network Context Did Remove Tagged Light Collection: %@", collection.tag);
    [collection removeLightCollectionObserver:self];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Add Light: %@", lightCollection, light);
    [light addLightObserver:self];
    
    _light = light;
    [allDevices reloadData];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSLog(@"Light Collection: %@ Did Remove Light: %@", lightCollection, light);
    [light removeLightObserver:self];
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
    NSLog(@"Light: %@ Did Change Label: %@", light, label);
    NSUInteger rowIndex = [self.lights indexOfObject:light];
}



@end
