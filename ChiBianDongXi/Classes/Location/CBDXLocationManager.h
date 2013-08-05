//
//  LocationManager.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/18/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CBDXLocationManagerDelegate <NSObject>

-(void) isSetLocationSuccessed:(BOOL) isResult;
-(void) isOpenedLocation:(BOOL) isResult;

@end

@interface CBDXLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager * locationManager;
@property (assign, nonatomic) id<CBDXLocationManagerDelegate> delegate;
@property (assign, nonatomic) BOOL isOpened;
@property (assign, nonatomic) BOOL isLocationed;
- (void) updateLocation;

@end
