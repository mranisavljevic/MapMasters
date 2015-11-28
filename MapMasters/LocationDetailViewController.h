//
//  LocationDetailViewController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"
#import "LocationService.h"
@import CoreLocation;
@import MapKit;
@import Parse;

typedef void(^LocationDetailViewControllerCompletion)(MKCircle *circle);

@interface LocationDetailViewController : UIViewController

@property (copy, nonatomic) NSString* annotationTitle;
//@property double radius;
@property CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) LocationDetailViewControllerCompletion completion;
@property BOOL addMode;
@property Reminder *reminder;

- (void)toggleAddUpdateView;

@end
