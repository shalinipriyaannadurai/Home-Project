//
//  DashBoardController_iPad.m
//  Home Project
//
//  Created by Shalini Priya A on 14/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "DashBoardController_iPad.h"
#import "Client.h"
@interface DashBoardController_iPad ()
@property (nonatomic,retain) UITableView *frequentDevices;
@property (nonatomic,retain) UITableView *allDevices;

@end

@implementation DashBoardController_iPad
@synthesize deviceList,frequentDevices,allDevices;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 60)];
    title.text=@"DashBoard";
    [title setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navi.png"]]];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.height, self.view.frame.size.width-60)];
    [subView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg.png"]]];

    
    UILabel *header=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 60)];
//    [header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"frequen_bg.png"]]];
    [header setBackgroundColor:[UIColor clearColor]];

    header.text=@"Frequently Used Devices";
    header.textColor=[UIColor whiteColor];

    [subView addSubview:header];

    frequentDevices  = [[UITableView alloc] initWithFrame:self.view.frame];
//    [frequentDevices setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"total_bg.png"]]];
    [frequentDevices setBackgroundColor:[UIColor clearColor]];

    frequentDevices.transform = CGAffineTransformMakeRotation(M_PI/-2);
    frequentDevices.showsVerticalScrollIndicator = NO;
    frequentDevices.frame = CGRectMake(0, 60, self.view.frame.size.height, 150);
    frequentDevices.delegate = self;
    frequentDevices.dataSource = self;
    frequentDevices.tag=1;
    [subView addSubview:frequentDevices];
    
    allDevices  = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.height, self.view.frame.size.width-210)];
//    [allDevices setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"total_bg.png"]]];
    [allDevices setBackgroundColor:[UIColor clearColor]];

    allDevices.delegate = self;
    allDevices.dataSource = self;
    allDevices.tag=2;
    [subView addSubview:allDevices];
    
    [self.view addSubview:subView];
    
    Client *client = [Client sharedClient];
    client.delegate=self;
    deviceList=[NSDictionary dictionary ];
    [client findSteward];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([deviceList count]<1) {
        return 0;
    }
    return [deviceList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if(tableView.tag==1){
            cell.frame=CGRectMake(0, 0, 300, 150);
            cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
   
        }
        else
        cell.frame=CGRectMake(0, 0, 1024, 150);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor whiteColor];
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_parts_bg.png"]]];

    }
    if ([deviceList count]>=1) {
        cell.textLabel.text=[[deviceList allKeys] objectAtIndex:indexPath.row];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1){
        return 300;
    }
    return 100;
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
    [self.frequentDevices reloadData];
    [self.allDevices reloadData];

}
@end
