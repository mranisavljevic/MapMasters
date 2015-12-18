//
//  LocationDetailViewController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface LocationDetailViewController : UIViewController

@property (strong, nonatomic) NSString* annotationTitle;
@property (strong, nonatomic) NSString* annotationSubtitle;
@property CLLocationCoordinate2D coordinate;

@end
