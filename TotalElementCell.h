//
//  TotalElementCell.h
//  Home Project
//
//  Created by Shalini Priya A on 17/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalElementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *elementImage;
@property (weak, nonatomic) IBOutlet UILabel *elementTitle;

@property (weak, nonatomic) IBOutlet UILabel *elementDescription;
@property (weak, nonatomic) IBOutlet UIImageView *on_offIcon;
@property (weak, nonatomic) IBOutlet UIImageView *numIcon;
@end
