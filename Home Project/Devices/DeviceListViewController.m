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

@interface DeviceListViewController ()

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    // Do any additional setup after loading the view.
    self.titleString.text = self.deviceName;

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

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
           return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"DeviceListingCell";
    DeviceListingCell *listingCell=(DeviceListingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (listingCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceListingCell" owner:self options:nil];
        listingCell = [nib objectAtIndex:0];
    }
     listingCell.frame=CGRectMake(0, 0, 320, 80);
   listingCell.backgroundColor=[UIColor clearColor];
    return listingCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DeviceSettings" sender:self];
}


@end
