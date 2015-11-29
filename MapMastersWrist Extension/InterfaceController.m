//
//  InterfaceController.m
//  MapMastersWrist Extension
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController() <WCSessionDelegate>

@property WCSession *sharedSession;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *reminderTable;
@property (strong, nonatomic) NSArray *reminderArray;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        self.sharedSession = [WCSession defaultSession];
        self.sharedSession.delegate = self;
        [self.sharedSession activateSession];
    }
//    [self getRecentReminders];
    
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
            NSDictionary *reminderObject = (NSDictionary*)self.reminderArray[i];
            if ([reminderObject objectForKey:@"title"] && [reminderObject objectForKey:@"radius"] && [reminderObject objectForKey:@"coordinate"]) {
                ReminderTableRowController *row = [self.reminderTable rowControllerAtIndex:i];
                [row.titleLabel setText:self.reminderArray[i][@"title"]];
            }
        }
    }
}

- (void)getRecentReminders:(NSDictionary*)context {
    NSArray *array = (NSArray*)[context objectForKey:@"reminders"];
    if (array) {
        self.reminderArray = array;
        [self setUpTable];
    }
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    
    [self getRecentReminders:applicationContext];

}

@end



