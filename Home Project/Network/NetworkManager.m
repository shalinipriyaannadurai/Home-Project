//
//  NetworkManager.m
//  Home Project
//
//  Created by shruthi on 04/11/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

-(void) getServerResponseFromURL:(NSURL *) serverUrl withHandler :(void (^) (id,NSError*))handler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                handler(json,error);
        });
    }];
}

@end
