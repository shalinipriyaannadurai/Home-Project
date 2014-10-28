//
//  DashBoardController_iPad.m
//  Home Project
//
//  Created by Shalini Priya A on 14/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DashBoardController_iPad.h"
#import "Client.h"
#import "ElementCell.h"
#import "TotalElementCell.h"
#import "ProfileViewController.h"
@interface DashBoardController_iPad ()
@property (nonatomic,retain) UITableView *frequentDevices;
@property (nonatomic,retain) UITableView *allDevices;
@property (nonatomic,retain) NSMutableArray *groupList;

@end

@implementation DashBoardController_iPad
@synthesize deviceList,frequentDevices,allDevices,indicator,subView,groupList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [indicator startAnimating];

    frequentDevices  = [[UITableView alloc] initWithFrame:self.view.frame];
    [frequentDevices setBackgroundColor:[UIColor clearColor]];
    frequentDevices.transform = CGAffineTransformMakeRotation(M_PI/-2);
    frequentDevices.showsVerticalScrollIndicator = NO;
    frequentDevices.frame = CGRectMake(0, 60, 1024, 100);
    frequentDevices.delegate = self;
    frequentDevices.dataSource = self;
    frequentDevices.tag=1;
    
    allDevices  = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 1024, 768-210)];
    [allDevices setBackgroundColor:[UIColor clearColor]];
    allDevices.delegate = self;
    allDevices.dataSource = self;
    allDevices.tag=2;
    [self.view addSubview:indicator];
    
    Client *client = [Client sharedClient];
    client.delegate=self;
    deviceList=[NSDictionary dictionary ];
    [client findSteward];
    deviceList=[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:@"Door"],@"device/security/door",[NSArray arrayWithObject:@"Hue"],@"device/light/hue",[NSArray arrayWithObject:@"Lifx"],@"device/light/lifx",[NSArray arrayWithObject:@"Chromecast"], @"device/video/chromecast",nil];
    groupList=[NSMutableArray array];
    for (NSString *group in [deviceList allKeys]) {
        if (![groupList containsObject:[group stringByDeletingLastPathComponent]]) {
            [groupList addObject:[group stringByDeletingLastPathComponent]];
        }
    }
    [subView addSubview:frequentDevices];
    [subView addSubview:allDevices];
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];
    [indicator stopAnimating];
    [indicator removeFromSuperview];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([deviceList count]<1) {
        return 1;
    }
    if(tableView.tag==1)
    return [deviceList count];
    else
        return [groupList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
        static NSString *CellIdentifier = @"Cell";
        ElementCell *cell = (ElementCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ElementCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
        cell.frame=CGRectMake(0, 0, 368, 100);
        cell.transform= CGAffineTransformMakeRotation(M_PI/2);
        [cell setBackgroundColor:[UIColor clearColor]];
        if ([deviceList count]>=1) {
                    cell.elementTitle.text=[[[deviceList allKeys] objectAtIndex:indexPath.row]lastPathComponent];
                    cell.elementDescription.text=@"This is description";
                    cell.elementSubDescription.text=@"This is subdescription";
                    [cell.elementImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",[cell.elementTitle.text lowercaseString]]]];
            if([cell.elementTitle.text isEqualToString:@"hue"]){
                cell.elementDescription.text=@"glowing";
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
        TotalElementCell *cell1 = (TotalElementCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TotalElements" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        cell1.frame=CGRectMake(0, 0, 1024, 150);
        [cell1 setBackgroundColor:[UIColor clearColor]];
        if ([groupList count]>=1) {
            cell1.elementTitle.text=[[groupList objectAtIndex:indexPath.row] lastPathComponent];
            [cell1.groupIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",[cell1.elementTitle.text lowercaseString]]]];
            if([cell1.elementTitle.text isEqualToString:@"light"]){
                cell1.numLabel.text=@"2";
                cell1.elementDescription.text=@"2 bulbs glowing";

            }
            if([cell1.elementTitle.text isEqualToString:@"security"]){
                [cell1.numIcon removeFromSuperview];
                [cell1.numLabel removeFromSuperview];
                [cell1.on_offIcon setImage:[UIImage imageNamed:@"on_icon.png"]];
                cell1.elementDescription.text=@"The door is locked";

            }
            if([cell1.elementTitle.text isEqualToString:@"video"]){
                [cell1.numIcon removeFromSuperview];
                [cell1.numLabel removeFromSuperview];
                [cell1.on_offIcon setImage:[UIImage imageNamed:@"off_icon.png"]];
                cell1.elementDescription.text=@"The video is paused";
                cell1.elementDescription.textColor=[UIColor redColor];
            }

        }

        return cell1;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(tableView.tag==1){
        return 368;
    }
    return 150;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Client Delegate Methods

- (void)stewardFoundWithAddress:(NSString *)ipAddress {
    NSLog(@"stewardFoundWithAddress: %@", ipAddress);
    [[Client sharedClient] availableDevices];
    
}

- (void)stewardNotFoundWithError:(NSError *)error {
    NSLog(@"stewardNotFoundWithError: %@", error);
    [indicator stopAnimating];
    [indicator removeFromSuperview];}

-(void)recievedPerformResponse:(NSString *)message {
    NSLog(@"json = %@", message);
    
}
-(void)receivedDeviceList:(NSString *)message{
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    NSLog(@"device list = %@", [JSON valueForKey:@"result"]);
    //deviceList=[JSON valueForKey:@"result"];
    [subView addSubview:frequentDevices];
    [subView addSubview:allDevices];
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];
    [indicator stopAnimating];
    [indicator removeFromSuperview];

}
- (IBAction)userTapped:(id)sender {
    ProfileViewController *userProfile=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    [self presentViewController:userProfile animated:YES completion:nil];
}

- (IBAction)rulesTapped:(id)sender {
}
@end
