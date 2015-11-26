//
//  LoginViewController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/25/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self completion]) {
        NSLog(@"Something's happening with completion");
    }
    NSLog(@"LoginVC just loaded...");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"LoginVG appearing...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
