//
//  Anagram.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "Anagram.h"

@implementation Anagram

- (BOOL)checkForAnagramWithString:(NSString *)stringOne checkAgainst:(NSString *)stringTwo {
    NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
    for (NSUInteger i=0; i<[stringOne length]; i++) {
        char character = [stringOne characterAtIndex:i];
        NSString *stringCharacter = [NSString stringWithUTF8String:&character];
        [arrayOne addObject:stringCharacter];
    }
    [arrayOne sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *arrayTwo = [[NSMutableArray alloc] init];
    for (NSUInteger i=0; i<[stringTwo length]; i++) {
        char character = [stringTwo characterAtIndex:i];
        NSString *stringCharacter = [NSString stringWithUTF8String:&character];
        [arrayTwo addObject:stringCharacter];
    }
    [arrayTwo sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSArray *copyOne = arrayOne;
    NSArray *copyTwo = arrayTwo;
    if (copyOne.count == copyTwo.count) {
        for (NSUInteger i = 0; i<copyOne.count; i++) {
            if ([[copyOne objectAtIndex:i] isEqualToString:[copyTwo objectAtIndex:i]]) {
                return NO;
            }
        }
    } else {
        return NO;
    }
    return YES;
}

@end
