//
//  Utility.h
//  Home Project
//
//  Created by shruthi on 31/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum HPDeviceType
{
    eLights = 0,
    eSecurity,
    eThermostat,
    eVideo
}HPDeviceType;

@interface Utility : NSObject
+(Utility *)sharedInstance;
-(BOOL) isIpad;
@end
