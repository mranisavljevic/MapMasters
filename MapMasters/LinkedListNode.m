//
//  LinkedListNode.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LinkedListNode.h"

@implementation LinkedListNode

- (instancetype)initWithValue:(NSString *)value{
    self.value = [[NSString alloc] initWithString:value];
    return self;
}

@end
