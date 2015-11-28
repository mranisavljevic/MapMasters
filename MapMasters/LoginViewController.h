//
//  LoginViewController.h
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/25/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

@import UIKit;
@import Parse;

typedef void(^LoginViewControllerCompletion)(void);

@interface LoginViewController : UIViewController

@property (copy, nonatomic) LoginViewControllerCompletion completion;
@property (weak, nonatomic) id delegate;

@end
