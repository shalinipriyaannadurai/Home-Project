//
//  ViewController.m
//  Home Project
//
//  Created by Shalini Priya A on 13/10/14.
//  Copyright (c) 2014 Shalini Priya A. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardController_iPad.h"
#import "Client.h"
@interface LoginViewController ()
@property NSArray *gestureRecognizers;
@property CGPoint previousLocation;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg.png"]]];
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
    CGRect hitRect = CGRectMake(499.0, 593.0, 16.0, 20.0);
    
    if(CGRectContainsPoint(hitRect, currentPoint))
        
    {
             DashBoardController_iPad *svc =[self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardController_iPad"];
             [svc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
             [self presentViewController:svc animated:YES completion:nil];

    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
