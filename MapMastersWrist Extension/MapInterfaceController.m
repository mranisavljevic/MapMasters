//
//  MapInterfaceController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/29/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "MapInterfaceController.h"

@interface MapInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceMap *map;

@end

@implementation MapInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([context isKindOfClass:[NSDictionary class]]) {
        if ([[context objectForKey:@"coordinate"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *coordinate = (NSDictionary*)[context objectForKey:@"coordinate"];
            NSNumber *latitude = [coordinate objectForKey:@"latitude"];
            NSNumber *longitude = [coordinate objectForKey:@"longitude"];
            self.location = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
            NSString *title = (NSString*)[context objectForKey:@"title"];
            [self setTitle:title];
        }
        self.point = MKMapPointForCoordinate(self.location);
        [self.map setVisibleMapRect:MKMapRectMake(self.point.x, self.point.y, 100, 100)];
        [self.map addAnnotation:self.location withPinColor:WKInterfaceMapPinColorPurple];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 100, 100);
        [self.map setRegion:region];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



