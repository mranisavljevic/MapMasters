//
//  InterfaceController.m
//  MapMastersWrist Extension
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *reminderTable;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
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
    [self.reminderTable setNumberOfRows:10 withRowType:@"ReminderTableRowController"];
    for (int i = 0; i < [self.reminderTable numberOfRows]; i++) {
        //
    }
}

@end



