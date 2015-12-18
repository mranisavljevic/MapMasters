//
//  UIColorClassExtension.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/27/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "UIColorClassExtension.h"

@implementation UIColor (UIColorClassExtension)

+ (UIColor*)darkBrownColor {
    return [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
}

+ (UIColor*)salmonColor {
    return [UIColor colorWithRed:1.000 green:0.733 blue:0.553 alpha:1.000];
}

+ (UIColor*)orangePinColor {
    return [UIColor colorWithRed:1.000 green:0.478 blue:0.000 alpha:0.800];
}

+ (UIColor*)orangeOverlayColor {
    return [UIColor colorWithRed:1.000 green:0.490 blue:0.020 alpha:0.750];
}

+ (UIColor*)greyOverlayBorderColor{
    return [UIColor colorWithRed:0.549 green:0.510 blue:0.475 alpha:0.750];
}

@end

