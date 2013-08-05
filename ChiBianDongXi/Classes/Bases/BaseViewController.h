//
//  BaseViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)BOOL hasLoaded;

-(void)show;

-(void)refreshUI;
-(void)loadListBarItem;

- (void)enableUserInterface;
- (void)unEnableUserInterface;

@end
