//
//  Utility.m
//  Home Project
//
//  Created by shruthi on 31/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

@implementation Utility
+(Utility *)sharedInstance {
    
    
     __strong static id instance = nil;
static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
  instance = [[self alloc]init];
  //NSLog(@"CRETAE SHARED INSTANCE");
   });
    
    return instance;

}

-(BOOL) isIpad{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
      return true;
    }
    else{
        return false;
    }
    
}

@end
