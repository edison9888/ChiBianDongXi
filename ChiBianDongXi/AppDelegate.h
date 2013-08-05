//
//  AppDelegate.h
//  ChiBianDongXi 2.0
//
//  Created by Andy Gu on 7/12/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"

@class SinaWeibo;

#ifndef kAppKey
#define kAppKey             @"3524632713"
#endif

#ifndef kAppSecret
#define kAppSecret          @"6a80ec0074dc6ffbee77684beddf0bbe"
#endif

#ifndef kAppRedirectURI
#define kAppRedirectURI     @"http://ifanbar.com"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow  *window;
@property (retain, nonatomic) SinaWeibo *sinaweibo;


+ (AppDelegate*)shareAppDelegate;
@end
