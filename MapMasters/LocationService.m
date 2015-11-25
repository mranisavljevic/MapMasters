//
//  LocationService.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LocationService.h"
@import CoreLocation;

@interface LocationService () <CLLocationManagerDelegate>

//- (void)startUpdatingLocation;
//- (void)stopUpdatingLocation;

@end

@implementation LocationService

+ (LocationService *)sharedService {
    static LocationService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedService = [[[self class] alloc] init];
    });
    return sharedService;
}

- (id)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.delegate locationServiceDidUpdateLocation:locations.lastObject];
    [self setLocation:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapView setShowsUserLocation:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if (region) {
        //Local notification here
    }
}

@end
