//
//  HPSceneViewController.h
//  Lightbulb
//
//  Created by SHALINI on 10/30/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPDevice.h"
@interface HPSceneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic,retain)NSMutableDictionary *scenes;
@property (nonatomic,retain)NSMutableDictionary *devices;

- (IBAction)addButtonTapped:(id)sender;
- (IBAction)typeButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@end