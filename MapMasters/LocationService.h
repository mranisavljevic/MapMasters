//
//  LocationService.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol LocationServiceDelegate <NSObject>

@optional
- (void)locationServiceDidUpdateLocation:(CLLocation*)location;

@end

@interface LocationService : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id delegate;

+ (LocationService *)sharedService;

@end
