//
//  LoginViewController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/25/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)signupButtonPressed:(UIButton *)sender;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self completion]) {
        NSLog(@"Something's happening with completion");
    }
    NSLog(@"LoginVC just loaded...");
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"LoginVG appearing...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpView {
    UIColor *salmonColor = [UIColor colorWithRed:1.000 green:0.733 blue:0.553 alpha:1.000];
    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    self.loginButton.backgroundColor = salmonColor;
    self.loginButton.layer.borderColor = [darkBrownColor CGColor];
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.cornerRadius = 15.0;
    self.signupButton.backgroundColor = salmonColor;
    self.signupButton.layer.borderWidth = 1.0;
    self.signupButton.layer.borderColor = [darkBrownColor CGColor];
    self.signupButton.layer.cornerRadius = 15.0;
    self.signupButton.alpha = 0.0;
    self.emailTextField.alpha = 0.0;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.emailTextField.alpha = (self.emailTextField.alpha == 0.0 ? 1.0 : 0.0);
        self.signupButton.alpha = (self.emailTextField.alpha == 0.0 ? 1.0 : 0.0);
    }];
}
- (IBAction)signupButtonPressed:(UIButton *)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
