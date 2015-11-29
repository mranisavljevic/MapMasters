//
//  InterfaceController.m
//  MapMastersWrist Extension
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *reminderTable;
@property (strong, nonatomic) NSArray *reminderArray;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        WCSession *sharedSession = [WCSession defaultSession];
        sharedSession.delegate = self;
        [sharedSession activateSession];
        if (sharedSession.applicationContext) {
            NSArray *array = sharedSession.applicationContext[@"reminders"];
            if (array) {
                self.reminderArray = array;
                [self setUpTable];
            }
        }
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

- (void)setUpTable {
    [self.reminderTable setNumberOfRows:[self.reminderArray count] withRowType:@"ReminderTableRowController"];
    for (int i = 0; i < self.reminderArray.count; i++) {
        if (self.reminderArray[i]) {
            if (self.reminderArray[i][@"title"] && self.reminderArray[i][@"radius"] && self.reminderArray[i][@"coordinate"]) {
                ReminderTableRowController *row = [self.reminderTable rowControllerAtIndex:i];
                [row.titleLabel setText:self.reminderArray[i][@"title"]];
            }
        }
    }
}

@end



