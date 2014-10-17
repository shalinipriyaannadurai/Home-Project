//
//  ElementCell.m
//  Home Project
//
//  Created by Shalini Priya A on 16/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "ElementCell.h"

@implementation ElementCell
@synthesize elementImage,elementSubDescription,elementDescription,elementTitle;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
