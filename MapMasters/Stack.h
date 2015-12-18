//
//  Stack.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

@property NSMutableArray* stack;
- (instancetype)initWithStack: (NSMutableArray*)stack;
- (void)addObject:(NSString*)string;
- (void)removeObject;

@end
