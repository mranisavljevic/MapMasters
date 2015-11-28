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
@property (strong, nonatomic) IBOutlet UIView *cancelButton;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonTopConstraint;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.loginButton.layer.cornerRadius = 5.0;
    self.signupButton.backgroundColor = salmonColor;
    self.signupButton.layer.borderWidth = 1.0;
    self.signupButton.layer.borderColor = [darkBrownColor CGColor];
    self.signupButton.layer.cornerRadius = 5.0;
    self.cancelButton.backgroundColor = salmonColor;
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [darkBrownColor CGColor];
    self.cancelButton.layer.cornerRadius = 5.0;
    self.emailTextField.alpha = 0.0;
    self.cancelButton.alpha = 0.0;
    self.navigationController.navigationBarHidden = YES;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    if (![self.usernameTextField.text isEqualToString:@""]) {
        if (![self.passwordTextField.text isEqualToString:@""]) {
            [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.userInfo[@"code"]);
                }
                if (user) {
                    if (self.completion) {
                        self.completion();
                    }
                }
            }];
        }
    } else {
        [self presentAlertController];
    }
}

- (IBAction)signupButtonPressed:(UIButton *)sender {
    if (self.emailTextField.alpha == 0.0) {
        [self toggleAlpha];
    } else {
        if (![self.usernameTextField.text isEqualToString:@""]) {
            if (![self.passwordTextField.text isEqualToString:@""]) {
                if (![self.emailTextField.text isEqualToString:@""]) {
                    PFUser *newUser = [PFUser user];
                    newUser.username = self.usernameTextField.text;
                    newUser.password = self.passwordTextField.text;
                    newUser.email = self.emailTextField.text;
                    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"%@", error.userInfo[@"code"]);
                        }
                        if (succeeded) {
                            if (self.completion) {
                                self.completion();
                            }
                        }
                    }];
                }
            }
        } else {
            [self presentAlertController];
        }
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self toggleAlpha];
}

- (void)presentAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Please enter a valid username and password." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)toggleAlpha {
    self.loginButtonTopConstraint.constant = (self.loginButtonTopConstraint.constant == 8 ? 96 : 8);
    [UIView animateWithDuration:0.4 animations:^{
        self.emailTextField.alpha = (self.emailTextField.alpha == 0.0 ? 1.0 : 0.0);
        self.cancelButton.alpha = (self.cancelButton.alpha == 0.0 ? 1.0 : 0.0);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
