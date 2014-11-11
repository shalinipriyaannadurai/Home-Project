//
//  HPSceneViewController.m
//  Lightbulb
//
//  Created by SHALINI on 10/30/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import "HPSceneViewController.h"
#import "HPAddSceneController.h"
#import "HPSceneGridCell.h"
#import "HPSceneTableCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface HPSceneViewController ()

- (IBAction)backButtonTapped:(id)sender;
@end

@implementation HPSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listView.hidden=YES;
    self.listView.delegate=self;
    self.listView.dataSource=self;
    self.gridView.delegate=self;
    self.gridView.dataSource=self;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    [self.gridView registerNib:[UINib nibWithNibName:@"HPSceneGridCell_iPhone" bundle:nil] forCellWithReuseIdentifier:@"SceneCell_iPhone"];
    else
    [self.gridView registerNib:[UINib nibWithNibName:@"HPSceneGridCell" bundle:nil] forCellWithReuseIdentifier:@"SceneCell"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"HPScenes"]==nil)
        self.scenes=[NSMutableDictionary dictionary];
    else
        self.scenes=[defaults valueForKey:@"HPScenes"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"HPScenes"]==nil) {
        self.scenes=[NSMutableDictionary dictionary];
    }
    else
        self.scenes=[defaults valueForKey:@"HPScenes"];
    
    [self.gridView reloadData];
    [self.listView reloadData];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addButtonTapped:(id)sender {
    NSLog(@"devices  %@",self.devices);
    if ([self.devices valueForKey:@"bulb"]!=nil) {
        HPAddSceneController *addScreenController;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            addScreenController=[[HPAddSceneController alloc]initWithNibName:@"HPAddSceneController" bundle:nil];
        }
        else{
            addScreenController=[[HPAddSceneController alloc]initWithNibName:@"HPAddSceneController_iPhone" bundle:nil];
        }
        
        addScreenController.devices=[self.devices valueForKey:@"bulb"];
        [self presentViewController:addScreenController animated:NO completion:nil];

    }
}

- (IBAction)typeButtonTapped:(id)sender {
    if (self.listView.hidden==YES) {
        self.gridView.hidden=YES;
        self.listView.hidden=NO;
        [sender setImage:[UIImage imageNamed:@"grid.png"] forState:UIControlStateNormal];
    }
    else{
        self.gridView.hidden=NO;
        self.listView.hidden=YES;
        [sender setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    }
}
-(void)infoButtonTapped:(UIButton *) sender{
    HPAddSceneController *addScreenController;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        addScreenController=[[HPAddSceneController alloc]initWithNibName:@"HPAddSceneController" bundle:nil];
    }
    else{
        addScreenController=[[HPAddSceneController alloc]initWithNibName:@"HPAddSceneController_iPhone" bundle:nil];
    }
    addScreenController.scene=[self getScene:[self.scenes valueForKey:[[self.scenes allKeys] objectAtIndex:sender.tag]]];
    addScreenController.devices=[self.devices valueForKey:@"bulb"];
    [self presentViewController:addScreenController animated:NO completion:nil];
}

-(HPScence *)getScene:(NSMutableDictionary *)param{
    HPScence *scene=[[HPScence alloc ]init];
    scene.name=[param valueForKey:@"name"];
    scene.sceneDescription=[param valueForKey:@"scenedescription"];
    scene.imageName=[param valueForKey:@"img_name"];
    
    for (NSDictionary *dict in [param valueForKey:@"param"]) {
        HPBulb *b=[[HPBulb alloc]init];
        b.name=[dict valueForKey:@"name"];
        b.brightness=[[dict valueForKey:@"brightness"]floatValue];
        b.deviceId=[dict valueForKey:@"deviceId"];
        b.status=[dict valueForKey:@"status"];
        b.lastupdated=[dict valueForKey:@"updated"];
        [scene.param addObject:b];
    }
    return scene;
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.scenes count];
}
-(UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout{
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HPSceneGridCell *cell;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        cell = (HPSceneGridCell*)[cv dequeueReusableCellWithReuseIdentifier:@"SceneCell_iPhone" forIndexPath:indexPath];
        [cell.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            }
    else{
        cell = (HPSceneGridCell*)[cv dequeueReusableCellWithReuseIdentifier:@"SceneCell" forIndexPath:indexPath];
    }
    
    if ([self.scenes count]>=1) {
        HPScence *tmp=[self getScene:[self.scenes valueForKey:[[self.scenes allKeys] objectAtIndex:[indexPath row]]]];
        cell.sceneName.text=tmp.name;
        cell.descriptionView.text=tmp.sceneDescription;
        if (tmp.imageName==nil || [tmp.imageName isEqualToString:@""]) {
            [cell.sceneImage setImage:[UIImage imageNamed:@"no_image.png"]];
        }
        else{
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[NSURL URLWithString:tmp.imageName] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
            cell.sceneImage.image = [UIImage imageWithData:data];
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
            cell.sceneImage.image = [UIImage imageNamed:@"no_image.png"];
        }];
        }
        cell.infoButton.tag=[indexPath row];
        [cell.infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HPScence *tmp=[self getScene:[self.scenes valueForKey:[[self.scenes allKeys] objectAtIndex:[indexPath row]]]];
    if (tmp.param!=nil && [tmp.param count]!=0) {
        for (HPBulb *b in tmp.param ) {
            float brightness=b.brightness;
            NSString *device=[NSMutableString stringWithFormat:@"/api/v1/device/perform/%@",b.deviceId];
            NSString *request = @"on";
            NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %f, \\\"color\\\": { \\\"model\\\": \\\"rgb\\\", \\\"rgb\\\": { \\\"r\\\": 255, \\\"g\\\": 255, \\\"b\\\": 255 }}}",brightness];
            [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPSceneTableCell *cell;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        cell= (HPSceneTableCell*)[tableView dequeueReusableCellWithIdentifier:@"ListCell_iPhone"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPSceneTableCell_iPhone" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else{
        cell= (HPSceneTableCell*)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPSceneTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }

    if ([self.scenes count]>=1) {
        HPScence *tmp=[self getScene:[self.scenes valueForKey:[[self.scenes allKeys] objectAtIndex:[indexPath row]]]];
        cell.sceneName.text=tmp.name;
        cell.descriptionView.text=tmp.sceneDescription;
        cell.backgroundColor=[UIColor clearColor];
        if (tmp.imageName==nil || [tmp.imageName isEqualToString:@""]) {
            [cell.sceneImage setImage:[UIImage imageNamed:@"no_image.png"]];
        }
        else{
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[NSURL URLWithString:tmp.imageName] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
            cell.sceneImage.image = [UIImage imageWithData:data];
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
            cell.sceneImage.image = [UIImage imageNamed:@"no_image.png"];
        }];
        }
        cell.infoButton.tag=[indexPath row];
        [cell.infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.scenes count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HPScence *tmp=[self getScene:[self.scenes valueForKey:[[self.scenes allKeys] objectAtIndex:[indexPath row]]]];
    if (tmp.param!=nil && [tmp.param count]!=0) {
        for (HPBulb *b in tmp.param ) {
            float brightness=b.brightness;
            NSString *device=[NSMutableString stringWithFormat:@"/api/v1/device/perform/%@",b.deviceId];
            NSString *request = @"on";
            NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %f, \\\"color\\\": { \\\"model\\\": \\\"rgb\\\", \\\"rgb\\\": { \\\"r\\\": 255, \\\"g\\\": 255, \\\"b\\\": 255 }}}",brightness];
            [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
        }
    }
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
