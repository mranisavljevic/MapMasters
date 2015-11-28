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

- (IBAction)removeReminderButtonPressed:(UIButton *)sender {
}

- (IBAction)updateReminderButtonPressed:(UIButton *)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
