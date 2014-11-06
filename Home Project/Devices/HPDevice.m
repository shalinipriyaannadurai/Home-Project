//
//  HPScene.m
//  Lightbulb
//
//  Created by SHALINI on 10/30/14.
//  Copyright (c) 2014 The Thing System. All rights reserved.
//

#import "HPDevice.h"

@implementation HPDevice
- (id) init
{
    if (self = [super init])
    {
        self.name=[[NSString alloc]init];
        self.status=[[NSString alloc]init];
        self.lastupdated=[[NSString alloc]init];
    }
    return self;
}

@end
@implementation HPBulb
- (id) init
{
    if (self = [super init])
    {
        self.brightness=50;
    }
    return self;
}
@end
@implementation HPVideo
- (id) init
{
    if (self = [super init])
    {
        self.duration=0;
        self.position=0;
        self.url=[[NSString alloc]init];
    }
    return self;
}
@end

@implementation HPScence
- (id) init
{
    if (self = [super init])
    {
        self.name=[[NSString alloc]init];
        self.imageName=[[NSString alloc]init];
        self.param=[NSMutableDictionary dictionary];
    }
    return self;
}
@end