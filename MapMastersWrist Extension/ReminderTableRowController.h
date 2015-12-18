//
//  ReminderTableRowController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/28/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface ReminderTableRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceMap *miniMap;

@end
