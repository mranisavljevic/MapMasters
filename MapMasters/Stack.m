//
//  Stack.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "Stack.h"


@implementation Stack

- (instancetype)initWithStack:(NSMutableArray *)stack {
    if (self = [super init]) {
        if (self) {
            self.stack = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)addObject:(NSString *)string {
    [self.stack insertObject:string atIndex:0];
}

- (void)removeObject {
    [self.stack removeObjectAtIndex:0];
}

@end
