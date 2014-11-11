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


- (BOOL)isDeviceWithId:(NSString *)inDeviceId
{
    BOOL retValue = NO;
    
    if([self.deviceId isEqualToString:inDeviceId])
        return YES;
    
    return retValue;
}

@end
@implementation HPBulb
- (id) init
{
    if (self = [super init])
    {
        //self.brightness=50;
    }
    return self;
}

- (HPBulb *) initWithData:(NSDictionary *)inData
{
    if (self = [super init])
    {
        self.name=[inData valueForKey:@"name"];
        self.status=[inData valueForKey:@"status"];
        if ([self.status isEqualToString:@"waiting"])
            self.status=@"off";
        self.brightness=[[[inData valueForKey:@"info"] valueForKey:@"brightness"] floatValue];
        self.lastupdated=[inData valueForKey:@"lastupdated"];

    }
    return self;
}


- (void) updateLightWithData:(NSDictionary *)inData
{
    self.deviceId=[[inData valueForKey:@"whoami"] stringByReplacingOccurrencesOfString:@"device/" withString:@""];
    self.name=[inData valueForKey:@"name"];
    self.status=[inData valueForKey:@"status"];
    if ([self.status isEqualToString:@"waiting"])
        self.status=@"off";
    self.brightness=[[[inData valueForKey:@"info"] valueForKey:@"brightness"] floatValue];

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


- (HPVideo *) initWithData:(NSDictionary *)inData
{
    if (self = [super init])
    {
        self.name=[inData valueForKey:@"name"];
        self.status=[inData valueForKey:@"status"];
        if ([self.status isEqualToString:@"waiting"])
            self.status=@"off";
        self.lastupdated=[inData valueForKey:@"lastupdated"];
        self.duration=0;
        self.position=0;
        self.url=[[NSString alloc]init];
    }
    return self;
}


- (void) updateLightWithData:(NSDictionary *)inData
{
    self.deviceId=[inData valueForKey:@"whoami"];
    self.name=[inData valueForKey:@"name"];
    self.status=[inData valueForKey:@"status"];
    self.position=[[[inData valueForKey:@"info"] valueForKey:@"position"]floatValue ];
    self.duration=[[[inData valueForKey:@"info"] valueForKey:@"duration"]floatValue ];
    self.url=[[inData valueForKey:@"info"] valueForKey:@"url"];

}

@end

@implementation HPScence
- (id) init
{
    if (self = [super init])
    {
        self.name=[[NSString alloc]init];
        self.sceneDescription=[[NSString alloc]init];
        self.imageName=[[NSString alloc]init];
        self.param=[NSMutableArray array];
    }
    return self;
}
@end