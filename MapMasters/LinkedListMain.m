//
//  LinkedListMain.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LinkedListMain.h"

@interface LinkedListMain ()

@property LinkedListNode *top;

@end

@implementation LinkedListMain

- (void)addNode:(LinkedListNode *)node {
    if (!self.top) {
        self.top = [[LinkedListNode alloc] initWithValue:node.value];
        return;
    }
    LinkedListNode *newNode = [[LinkedListNode alloc] initWithValue:node.value];
    LinkedListNode *current = self.top;
    while (current.next) {
        current = current.next;
    }
    current.next = newNode;
}

- (NSString*)removeNode {
    if (!self.top) {
        return nil;
    }
    LinkedListNode *removedNode = self.top;
    if (removedNode.next) {
        self.top = removedNode.next;
    } else {
        self.top = nil;
    }
    return removedNode.value;
}


@end
