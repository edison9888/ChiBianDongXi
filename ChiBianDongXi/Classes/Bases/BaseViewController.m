//
//  BaseViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize hasLoaded = _hasLoaded;
@synthesize delegate = _delegate;

-(void)refreshUI
{
    return;
}

-(void)show
{
    
}

-(void)show:(BOOL)animated
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showList:)];
//    item.tintColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC addPanGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC removePanGestureRecognizer];
}

- (void)enableUserInterface
{
    self.view.userInteractionEnabled = YES;
}
- (void)unEnableUserInterface
{
    self.view.userInteractionEnabled = NO;
}

-(void)loadListBarItem
{
    NSLog(@"-->%@",self.navigationItem);
}

-(void)showList:(id)sender
{
    [self.delegate fold];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
