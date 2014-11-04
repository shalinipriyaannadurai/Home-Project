//
//  NetworkManager.h
//  Home Project
//
//  Created by shruthi on 04/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
-(void) getServerResponseFromURL:(NSURL *) serverUrl withHandler :(void (^) (id,NSError*))handler;
@end
