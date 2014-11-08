//
//  ViewController.m
//  Home Project
//
//  Created by Shalini Priya A on 13/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardController.h"
#import "Client.h"
#import "Utility.h"
@interface LoginViewController ()
@property NSArray *gestureRecognizers;
@property CGPoint previousLocation;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AddSwipeGesture];
   
}
-(void)AddSwipeGesture{
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToUnlock:)];
    [self.swipeUnlock addGestureRecognizer:panGestureRecognizer];

    [self.swipeUnlock setUserInteractionEnabled:YES];

    
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _dotsView.hidden=TRUE;
}

-(void)handleSwipeToUnlock:(UIPanGestureRecognizer *)panGestureRecognizer {

    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
    self.swipeUnlock.center = touchLocation;
    CGPoint currentPoint = [panGestureRecognizer locationInView:self.view];
    CGRect hitRect = [_unlock frame];
    
    
   NSString *storyboardString = nil;
   
   if ([[Utility sharedInstance]isIpad]) {
       
       storyboardString = [NSString stringWithFormat:@"Main_iPad"];
       
   }
   else {
       storyboardString = [NSString stringWithFormat:@"Main_iPhone"];
   }
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardString bundle:[NSBundle mainBundle]];
    
    if(CGRectContainsPoint(hitRect, currentPoint))
        
    {
           /*  DashBoardController *svc =[storyBoard instantiateViewControllerWithIdentifier:@"DashBoardController"];
            
             [svc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
         NSLog(@"%@--- %@",svc.navigationController,svc.parentViewController);
             [self presentViewController:svc animated:YES completion:nil];*/
        
        UINavigationController *svcNavController =[storyBoard instantiateViewControllerWithIdentifier:@"DashBoardParentController"];
        [svcNavController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self presentViewController:svcNavController animated:YES completion:nil];
        

    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
