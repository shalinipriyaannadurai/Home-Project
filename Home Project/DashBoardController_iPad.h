//
//  DashBoardController_iPad.h
//  Home Project
//
//  Created by Shalini Priya A on 14/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardController_iPad : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)NSDictionary *deviceList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *subView;

- (IBAction)userTapped:(id)sender;
- (IBAction)rulesTapped:(id)sender;
@end
