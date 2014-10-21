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
@interface DashBoardController_iPad ()
@property (nonatomic,retain) UITableView *frequentDevices;
@property (nonatomic,retain) UITableView *allDevices;

@end

@implementation DashBoardController_iPad
@synthesize deviceList,frequentDevices,allDevices,indicator,subView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [indicator startAnimating];

    frequentDevices  = [[UITableView alloc] initWithFrame:self.view.frame];
    [frequentDevices setBackgroundColor:[UIColor clearColor]];
    frequentDevices.transform = CGAffineTransformMakeRotation(M_PI/-2);
    frequentDevices.showsVerticalScrollIndicator = NO;
    frequentDevices.frame = CGRectMake(0, 60, self.view.frame.size.height, 100);
    frequentDevices.delegate = self;
    frequentDevices.dataSource = self;
    frequentDevices.tag=1;
    
    allDevices  = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.height, self.view.frame.size.width-210)];
    [allDevices setBackgroundColor:[UIColor clearColor]];
    allDevices.delegate = self;
    allDevices.dataSource = self;
    allDevices.tag=2;
    [self.view addSubview:indicator];
    
    Client *client = [Client sharedClient];
    client.delegate=self;
    deviceList=[NSDictionary dictionary ];
    [client findSteward];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([deviceList count]<1) {
        return 10;
    }
    return [deviceList count];
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
                    cell.elementTitle.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
                    cell.elementDescription.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
                    cell.elementSubDescription.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
                    [cell.elementImage setImage:[UIImage imageNamed:@"bulb_icon.png"]];
            
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
        if ([deviceList count]>=1) {
            cell1.elementTitle.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
            cell1.elementDescription.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
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
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if(tableView.tag==1){
        return 368;
    }
    return 150;
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
    [indicator removeFromSuperview];
}

-(void)recievedPerformResponse:(NSString *)message {
    NSLog(@"json = %@", message);
    
}
-(void)receivedDeviceList:(NSString *)message{
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    NSLog(@"device list = %@", [JSON valueForKey:@"result"]);
    deviceList=[JSON valueForKey:@"result"];
    [subView addSubview:frequentDevices];
    [subView addSubview:allDevices];
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];
    [indicator stopAnimating];
    [indicator removeFromSuperview];

}
@end
