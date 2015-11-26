//
//  Reminder.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/25/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Parse/Parse.h>

@interface Reminder : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property float radius;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSString *userId;

@end
