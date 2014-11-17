//
//  HPAddSceneControllerViewController.h
//  Lightbulb
//
//  Created by SHALINI on 11/7/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Client.h"
#import "HPDevice.h"
@interface HPAddSceneController: UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,ClientDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceList;
@property (nonatomic,retain)NSMutableArray *devices;
@property (weak, nonatomic) IBOutlet UITextField *sceneName;
@property (weak, nonatomic) IBOutlet UIImageView *sceneImage;
@property (retain, nonatomic) HPScence *scene;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *hpSceneDesc;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)addButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;
@end