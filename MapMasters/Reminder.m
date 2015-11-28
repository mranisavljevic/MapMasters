//
//  Reminder.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/25/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic radius;
@dynamic userId;
@dynamic enabled;
@dynamic objectId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Reminder";
}

@end
