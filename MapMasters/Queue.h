//
//  Queue.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

@property NSMutableArray *queue;
- (instancetype)initWithQueue: (NSMutableArray*) queue;
- (void)enqueue:(NSNumber*)number;
- (void)dequeue;

@end
