//
//  ReminderTableRowController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/28/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

@import UIKit;
@import WatchKit;
#import "Reminder.h"

@interface ReminderTableRowController : NSObject

@property (weak, nonatomic) Reminder *reminder;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *title;
@property (weak, nonatomic) IBOutlet WKInterfaceMap *miniMap;

@end
