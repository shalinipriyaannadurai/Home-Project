//
//  HPScene.h
//  Lightbulb
//
//  Created by SHALINI on 10/30/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPDevice : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *deviceId;
@property(nonatomic,retain)NSString *lastupdated;
@end


@interface HPBulb : HPDevice
@property(nonatomic,assign)float brightness;
@end


@interface HPVideo : HPDevice
@property(nonatomic,retain)NSString *url;
@property(nonatomic,assign)float position;
@property(nonatomic,assign)int duration;


@end
@interface HPScence : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *imageName;
@property(nonatomic,retain)NSDictionary *param;
@end
