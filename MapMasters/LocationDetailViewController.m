//
//  LocationDetailViewController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/24/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveReminderButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeReminderButton;
@property (weak, nonatomic) IBOutlet UIButton *updateReminderButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateButtonTopConstraint;

- (IBAction)saveReminderButtonPressed:(UIButton *)sender;
- (IBAction)removeReminderButtonPressed:(UIButton *)sender;
- (IBAction)updateReminderButtonPressed:(UIButton *)sender;

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addMode = YES;
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpView {
    self.titleTextField.delegate = self;
    self.radiusTextField.delegate = self;
    UIColor *salmonColor = [UIColor colorWithRed:1.000 green:0.733 blue:0.553 alpha:1.000];
    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    
    self.addMode = YES;
    
    self.saveReminderButton.backgroundColor = salmonColor;
    self.saveReminderButton.layer.borderColor = [darkBrownColor CGColor];
    self.saveReminderButton.layer.borderWidth = 1.0;
    self.saveReminderButton.layer.cornerRadius = 15.0;
    [self.titleTextField becomeFirstResponder];
    
    self.titleLabel.alpha = 0.0;
    self.radiusLabel.alpha = 0.0;
    
    if (self.addMode) {
        if (self.reminder) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", self.titleLabel.text, self.reminder.name];
            self.radiusLabel.text = [NSString stringWithFormat:@"%@: %.2f", self.radiusLabel.text, self.reminder.radius];
        }
    }
    
    self.removeReminderButton.backgroundColor = salmonColor;
    self.removeReminderButton.layer.borderColor = [darkBrownColor CGColor];
    self.removeReminderButton.layer.borderWidth = 1.0;
    self.removeReminderButton.layer.cornerRadius = 15.0;
    self.removeReminderButton.alpha = 0.0;
    
    self.updateReminderButton.backgroundColor = salmonColor;
    self.updateReminderButton.layer.borderColor = [darkBrownColor CGColor];
    self.updateReminderButton.layer.borderWidth = 1.0;
    self.updateReminderButton.layer.cornerRadius = 15.0;
    self.updateReminderButton.alpha = 0.0;
}

- (void)toggleAddUpdateView {
    self.titleTextField.alpha = !self.addMode ? 1.0 : 0.0;
    self.radiusTextField.alpha = !self.addMode ? 1.0 : 0.0;
    self.saveReminderButton.alpha = !self.addMode ? 1.0 : 0.0;
    self.titleLabel.alpha = self.addMode ? 1.0 : 0.0;
    self.radiusLabel.alpha = self.addMode ? 1.0 : 0.0;
    self.removeReminderButton.alpha = self.addMode ? 1.0 : 0.0;
    self.updateReminderButton.alpha = self.addMode ? 1.0 : 0.0;
    self.addMode = !self.addMode ? NO : YES;
}

- (IBAction)saveReminderButtonPressed:(UIButton *)sender {
    if (self.reminder) {
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Reminder"];
        [query whereKey:@"objectId" equalTo:self.reminder.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.userInfo);
            }
            if ([object isKindOfClass:[Reminder class]]) {
                Reminder *reminder = (Reminder*)object;
                reminder.name = self.titleTextField.text;
                reminder.radius = self.radiusTextField.text.floatValue;
                [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (self.completion) {
                        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                            CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:self.radiusTextField.text.floatValue identifier:self.titleTextField.text];
                            [[[LocationService sharedService] locationManager] startMonitoringForRegion:region];
                            self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:self.radiusTextField.text.doubleValue]);
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }
                }];
            }
        }];
    } else {
        Reminder *reminder = [[Reminder alloc] init];
        reminder.name = self.titleTextField.text;
        reminder.radius = self.radiusTextField.text.floatValue;
        reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        reminder.userId = [[PFUser currentUser] objectId];
        reminder.enabled = YES;
        [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (self.completion) {
                if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:self.radiusTextField.text.floatValue identifier:self.titleTextField.text];
                    [[[LocationService sharedService] locationManager] startMonitoringForRegion:region];
                    self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:self.radiusTextField.text.doubleValue]);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }];
    }
}

- (IBAction)removeReminderButtonPressed:(UIButton *)sender {
    if (self.reminder) {
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Reminder"];
        [query whereKey:@"objectId" equalTo:self.reminder.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.userInfo);
            }
            if ([object isKindOfClass:[Reminder class]]) {
                Reminder *reminder = (Reminder*)object;
                reminder.enabled = NO;
                [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.userInfo);
                    }
                    if (succeeded) {
                        if (self.completion) {
                            self.completion(nil);
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }
                }];
            }
        }];
    }
}

- (IBAction)updateReminderButtonPressed:(UIButton *)sender {
    self.titleTextField.text = self.reminder.name;
    self.updateButtonTopConstraint.constant = self.updateButtonTopConstraint.constant == 96 ? 8 : 96;
    self.radiusTextField.text = [NSString stringWithFormat:@"%.2f", self.reminder.radius];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        self.saveReminderButton.alpha = self.saveReminderButton.alpha == 1.0 ? 0.0 : 1.0;
        self.titleTextField.alpha = self.titleTextField.alpha == 1.0 ? 0.0 : 1.0;
        self.radiusTextField.alpha = self.radiusTextField.alpha == 1.0 ? 0.0 : 1.0;
        self.titleLabel.alpha = self.titleLabel.alpha == 1.0 ? 0.0 : 1.0;
        self.radiusLabel.alpha = self.radiusLabel.alpha == 1.0 ? 0.0 : 1.0;
    }];
    [self.updateReminderButton setTitle:([[self.updateReminderButton titleForState:UIControlStateNormal] isEqualToString: @"Update Reminder"] ? @"Cancel" : @"Update Reminder") forState:UIControlStateNormal];
    [self.updateReminderButton setTitle:([[self.updateReminderButton titleForState:UIControlStateNormal] isEqualToString: @"Update Reminder"] ? @"Cancel" : @"Update Reminder") forState:UIControlStateSelected];
    [self.updateReminderButton setTitle:([[self.updateReminderButton titleForState:UIControlStateNormal] isEqualToString: @"Update Reminder"] ? @"Cancel" : @"Update Reminder") forState:UIControlStateFocused];
    [self.updateReminderButton setTitle:([[self.updateReminderButton titleForState:UIControlStateNormal] isEqualToString: @"Update Reminder"] ? @"Cancel" : @"Update Reminder") forState:UIControlStateHighlighted];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
