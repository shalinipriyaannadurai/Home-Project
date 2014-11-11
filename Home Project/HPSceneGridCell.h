//
//  HPSceneGridCell.h
//  Lightbulb
//
//  Created by SHALINI on 10/31/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSceneGridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *sceneName;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *sceneImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@end
