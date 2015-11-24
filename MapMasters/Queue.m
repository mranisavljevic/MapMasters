//
//  Queue.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "Queue.h"

@implementation Queue

- (instancetype)initWithQueue:(NSMutableArray *)queue {
    if (self = [super init]) {
        if (self) {
            self.queue = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)enqueue:(NSNumber *)number {
    [self.queue addObject:number];
}

- (void)dequeue {
    [self.queue removeObjectAtIndex:0];
}

@end
