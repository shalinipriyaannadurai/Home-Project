//
//  AddScreenController.m
//  Lightbulb
//
//  Created by SHALINI on 10/30/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import "HPAddSceneController.h"
#import "HPTableViewCell.h"//;
#import "HPDevice.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Client.h"
@interface HPAddSceneController ()

@property (nonatomic,assign)bool isExistingScene;
@property (nonatomic,retain)NSMutableArray *sceneDevices;


@end

@implementation HPAddSceneController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        [self.sceneName setDelegate:self];
        [self.sceneName setReturnKeyType:UIReturnKeyDone];
        [self.sceneName addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.hpSceneDesc setDelegate:self];
        [self.hpSceneDesc setReturnKeyType:UIReturnKeyDone];
        [self.hpSceneDesc addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];

    }

//    HPBulb *b1=[[HPBulb alloc]init];
//    b1.name=@"hue";
//    b1.brightness=40;
//    b1.deviceId=@"2";
//    HPBulb *b2=[[HPBulb alloc]init];
//    b2.name=@"lifx";
//    b2.brightness=40;
//    b2.deviceId=@"3";
//    self.devices=[NSMutableArray arrayWithObjects:b1,b2,nil];
    self.deviceList.delegate=self;
    self.deviceList.dataSource=self;
    // Do any additional setup after loading the view from its nib.
    if (self.scene!=nil) {
        self.isExistingScene=YES;
        self.deleteButton.hidden=NO;
        self.sceneName.text=self.scene.name;
        self.hpSceneDesc.text=self.scene.sceneDescription;
        [self setImage];
        if([self.scene.param count]!=0){
            self.sceneDevices=self.scene.param;
            [self.deviceList reloadData];
        }
    }
    else{
        self.scene=[[HPScence alloc]init];
        self.isExistingScene=NO;
    }
}
-(void)textFieldFinished:(id)sender{
    [sender resignFirstResponder];
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

- (IBAction)addButtonTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)deleteButtonTapped:(id)sender {
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"HPScenes"]!=nil) {
        [p addEntriesFromDictionary:[defaults valueForKey:@"HPScenes"]];
        if ([p valueForKey:self.scene.name]!=nil) {
            [p removeObjectForKey:self.scene.name];
        }
        [defaults setObject:p forKey:@"HPScenes"];
    }
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
 
}

- (IBAction)saveButtonTapped:(id)sender {
    self.scene.name=self.sceneName.text;
    self.scene.sceneDescription=self.hpSceneDesc.text;
    
    [self.scene.param removeAllObjects];
    for (int i=2;i<=[self.devices count]*2;i=i+2){
        UIView *rButton=[self.deviceList viewWithTag:i];
        if ([rButton isKindOfClass:[UIButton class]]==YES && ((UIButton*)rButton).selected==YES) {
            ((HPBulb *)[self.devices objectAtIndex:rButton.tag/2-1]).brightness=((UISlider *)[self.deviceList viewWithTag:rButton.tag-1]).value;
            [self.scene.param addObject:[self.devices objectAtIndex:rButton.tag/2-1]];
        }
        if ([rButton isKindOfClass:[UIButton class]]==YES && ((UIButton*)rButton).selected==NO) {
       
        }
    }
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"HPScenes"]!=nil) {
        [p addEntriesFromDictionary:[defaults valueForKey:@"HPScenes"]];
    }
    [p addEntriesFromDictionary:[self prepareSceneParam]];
    [defaults setObject:p forKey:@"HPScenes"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(NSMutableDictionary *)prepareSceneParam{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:self.scene.name forKey:@"name"];
    [param setObject:self.scene.sceneDescription forKey:@"scenedescription"];
    [param setObject:self.scene.imageName forKey:@"img_name"];
    [param setObject:[NSMutableArray array] forKey:@"param"];
    for (HPBulb *b in self.scene.param) {
        [[param valueForKey:@"param"]addObject:[NSDictionary dictionaryWithObjectsAndKeys:b.deviceId,@"deviceId",b.name,@"name",[NSNumber numberWithFloat:b.brightness],@"brightness", b.status,@"status",b.lastupdated,@"updated", nil] ];
    }
    return [NSMutableDictionary dictionaryWithObject:param forKey:self.scene.name];
}
-(void)setImage{
    if (self.scene.imageName==nil || [self.scene.imageName isEqualToString:@""]) {
        [self.sceneImage setImage:[UIImage imageNamed:@"no_image.png"]];
    }
    else{
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[NSURL URLWithString:self.scene.imageName] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
            self.sceneImage.image = [UIImage imageWithData:data];
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
            [self.sceneImage setImage:[UIImage imageNamed:@"no_image.png"]];
            
        }];
    }
}
//- (NSUInteger)supportedInterfaceOrientations{
////    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//        return UIInterfaceOrientationMaskLandscape;
////    }
////    return UIInterfaceOrientationMaskAll;
//}
- (void)radioButtonTapped:(id)sender {
    if (((UIButton *)sender).selected==NO) {
        ((UIButton *)sender).selected=YES;
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else{
        ((UIButton *)sender).selected=NO;
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"Unchecked@2x.png"] forState:UIControlStateNormal];
        
    }
}
-(void)didBrightnessValueChange:(id)sender {
    int sliderTag=((UISlider*)sender).tag/2;
    float brightness=((UISlider*)sender).value;
    HPBulb *bulb=[self.devices objectAtIndex:sliderTag];
    bulb.brightness=brightness;
    NSString *device = [NSString stringWithFormat:@"/api/v1/device/perform/%@",bulb.deviceId ];
    NSString *request = @"on";
    NSString *parameters = [NSString stringWithFormat:@"{ \\\"brightness\\\": %f, \\\"color\\\": { \\\"model\\\": \\\"rgb\\\", \\\"rgb\\\": { \\\"r\\\": 255, \\\"g\\\": 255, \\\"b\\\": 255 }}}",brightness];
    [[Client sharedClient] performWithDevice:device andRequest:request andParameters:parameters];
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HPTableViewCell *cell ;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        cell= (HPTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"HPTableViewCell_iPhone"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPTableViewCell_iPhone" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    else{
    cell= (HPTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"tablecell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.isDeviceSelected.tag=[indexPath row]*2+2;
    cell.isDeviceSelected.selected=NO;
    [cell.isDeviceSelected addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    HPBulb *bulb=[self.devices objectAtIndex:[indexPath row] ];
    NSString *devId=bulb.deviceId;
    cell.deviceName.text=bulb.name;
    cell.brightnessSlider.tag=[indexPath row]*2+1;
    [cell.brightnessSlider setValue: (float)bulb.brightness];
    [cell.brightnessSlider addTarget:self action:@selector(didBrightnessValueChange:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"brigthness  %f,  %f",cell.brightnessSlider.value   ,bulb.brightness);
  
    if (self.isExistingScene==YES ){
        for (HPBulb *b in self.sceneDevices) {
            if([b.deviceId isEqualToString:devId]==YES){
                cell.isDeviceSelected.selected=YES;
                [cell.isDeviceSelected setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [cell.brightnessSlider setValue: b.brightness];
                
            }
        }
    }
    NSLog(@"brigthness  %f",cell.brightnessSlider.value);
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.devices count];
}

#pragma mark - UIImagePickerDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"ifo dict  %@",info);
    self.scene.imageName=[NSString stringWithFormat:@"%@",[info valueForKey:UIImagePickerControllerReferenceURL]];
    [self setImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
