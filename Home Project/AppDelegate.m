//
//  AppDelegate.m
//  Home Project
//
//  Created by Shalini Priya A on 13/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "AppDelegate.h"
#import "Client.h"
#import "LocalAuthentication/LocalAuthentication.h"
#import "Utility.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    Client *client = [Client sharedClient];
    NSLog(@"Client Library v%@", [Client version]);
    client.debug = YES;
    [self authenticateUser];
    return YES;
}
-(void)authenticateUser{
    NSString *storyboardString = nil;
    
    if ([[Utility sharedInstance]isIpad]) {
        
        storyboardString = [NSString stringWithFormat:@"Main_iPad"];
        
    }
    else {
        storyboardString = [NSString stringWithFormat:@"Main_iPhone"];
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardString bundle:[NSBundle mainBundle]];
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    NSString *reasonString = @"Authentication is needed to access your app";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonString reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             msg =@"Success";
             dispatch_async(dispatch_get_main_queue(), ^{
                 UINavigationController *svcNavController =[storyBoard instantiateViewControllerWithIdentifier:@"DashBoardParentController"];
                 [svcNavController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                 
                 [self.window setRootViewController:svcNavController ];
             });
             
             
         } else {
             msg = [NSString stringWithFormat:@"Fail with reason %@", authenticationError.localizedDescription];
         }
         // [self printResult:self.textView message:msg];
     }];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
