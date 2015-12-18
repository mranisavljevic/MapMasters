//
//  MapInterfaceController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/29/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

@import WatchKit;
@import UIKit;
@import CoreLocation;
@import MapKit;

@interface MapInterfaceController : WKInterfaceController

@property CLLocationCoordinate2D location;
@property MKMapPoint point;

@end
