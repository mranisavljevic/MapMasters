//
//  SumNumbersInString.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "SumNumbersInString.h"

@implementation SumNumbersInString

- (NSNumber*)sumNumbersInString:(NSString*)string {
    int total = 0;
    NSArray *stringArray = @[@""];
    for (NSUInteger i=0; i<[string length]; i++) {
        char character = [string characterAtIndex:i];
        NSString *stringCharacter = [NSString stringWithUTF8String:&character];
        stringArray = [stringArray arrayByAddingObject:stringCharacter];
    }
    for (NSString *character in stringArray) {
        total += [character intValue];
    }
    NSNumber *answer = [[NSNumber alloc] initWithInt:total];
    return answer;
}

@end
