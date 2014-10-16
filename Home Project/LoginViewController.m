//
//  ViewController.m
//  Home Project
//
//  Created by Shalini Priya A on 13/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardController_iPad.h"
#import "Client.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   /* UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"loginbg.png"] drawInRect:self.view.frame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg.png"]]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender {
//    ((DashBoardController_iPad *)[self.childViewControllers objectAtIndex:0]).deviceList=
//    Client *client = [Client sharedClient];
//    client.delegate=self;
//    deviceList=[NSDictionary dictionary ];
//    [client findSteward];
//
}
@end
