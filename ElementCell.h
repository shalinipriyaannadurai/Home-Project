//
//  ElementCell.h
//  Home Project
//
//  Created by Shalini Priya A on 16/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *elementImage;
@property (weak, nonatomic) IBOutlet UILabel *elementTitle;

@property (weak, nonatomic) IBOutlet UILabel *elementDescription;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *elementSubDescription;
- (IBAction)statusButtonTapped:(id)sender;
@end
