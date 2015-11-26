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

- (IBAction)saveReminderButtonPressed:(UIButton *)sender;

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpView {
    self.titleTextField.delegate = self;
    self.radiusTextField.delegate = self;
    UIColor *salmonColor = [UIColor colorWithRed:1.000 green:0.733 blue:0.553 alpha:1.000];
    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    self.saveReminderButton.backgroundColor = salmonColor;
    self.saveReminderButton.layer.borderColor = [darkBrownColor CGColor];
    self.saveReminderButton.layer.borderWidth = 1.0;
    self.saveReminderButton.layer.cornerRadius = 15.0;
    [self.titleTextField becomeFirstResponder];
}

- (IBAction)saveReminderButtonPressed:(UIButton *)sender {
    Reminder *reminder = [[Reminder alloc] init];
    reminder.name = self.titleTextField.text;
    reminder.radius = self.radiusTextField.text.floatValue;
    reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    reminder.userId = [[PFUser currentUser] objectId];
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
