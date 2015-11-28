//
//  MapViewController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "LocationDetailViewController.h"
#import "LoginViewController.h"
#import "Stack.h"
#import "Queue.h"
#import "Anagram.h"
@import MapKit;
@import CoreLocation;
@import Parse;
@import ParseUI;

@interface MapViewController () <LocationServiceDelegate, MKMapViewDelegate/*, LoginViewControllerDelegate*/>

@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (strong, nonatomic) NSArray *reminders;
- (IBAction)longPressGestureRecognized:(id)sender;
- (IBAction)tapGestureRecognized:(id)sender;
@property (strong, nonatomic) NSArray *monitoredRegions;
@property (strong, nonatomic) NSArray *monitoredOverlays;
@property Stack *stack;
@property Queue *queue;
@property Anagram *anagram;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
//    [self testStack];
//    [self testQueue];
//    [self testAnagram];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser]) {
        [self loadRemindersFromParse];
        [self addAdditionalUI];
    }
    self.navigationController.navigationBarHidden = NO;
    [[LocationService sharedService] setDelegate:self];
    [[LocationService sharedService]setMapView:self.locationMapView];
    [[[LocationService sharedService] locationManager] startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[[LocationService sharedService] locationManager] stopUpdatingLocation];
}

- (void)setUpView {
    
    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    self.locationMapView.mapType = MKMapTypeSatellite;
    self.locationMapView.layer.cornerRadius = 15.0;
    self.locationMapView.layer.borderColor = [darkBrownColor CGColor];
    self.locationMapView.layer.borderWidth = 1.0;
}

- (void)loadRemindersFromParse {
    for (CLCircularRegion *region in self.monitoredRegions) {
        [[[LocationService sharedService] locationManager] stopMonitoringForRegion:region];
    }
    self.monitoredRegions = [NSArray array];
    [self.locationMapView removeOverlays:self.monitoredOverlays];
    self.monitoredOverlays = [NSArray array];
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Reminder"];
    [query whereKey:@"userId" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.userInfo);
        }
        if (objects) {
            self.reminders = [[NSArray alloc] initWithArray:objects];
            for (Reminder *reminder in self.reminders) {
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
                if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:reminder.radius identifier:reminder.name];
                    self.monitoredRegions = [self.monitoredRegions arrayByAddingObject:region];
                    [[[LocationService sharedService] locationManager] startMonitoringForRegion:region];
                    MKCircle *circle = [MKCircle circleWithCenterCoordinate:location radius:reminder.radius];
                    self.monitoredOverlays = [self.monitoredOverlays arrayByAddingObject:circle];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.locationMapView addOverlay:circle];
                    }];
                }
            }
        }
    }];
}

- (void)setRegion: (MKCoordinateRegion)region {
    [self.locationMapView setRegion:region animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LocationDetailViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[LocationDetailViewController class]]) {
            LocationDetailViewController *detailVC = (LocationDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[Reminder class]]) {
                Reminder *reminder = (Reminder*)sender;
                detailVC.reminder = reminder;
                [detailVC loadViewIfNeeded];
                if (detailVC.addMode) {
                    [detailVC toggleAddUpdateView];
                }
            } else {
                MKAnnotationView *annotationView = (MKAnnotationView *)sender;
                detailVC.coordinate = annotationView.annotation.coordinate;
                detailVC.annotationTitle = annotationView.annotation.title;
                if (!detailVC.addMode) {
                    [detailVC toggleAddUpdateView];
                }
                __weak typeof(self) weakSelf = self;
                detailVC.completion = ^(MKCircle *circle) {
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf.locationMapView removeAnnotation:annotationView.annotation];
                    [strongSelf.locationMapView addOverlay:circle];
                };
            }
        }
    }
    if ([segue.identifier isEqualToString:@"LoginViewController"]) {
        LoginViewController *loginVC = (LoginViewController *)segue.destinationViewController;
        loginVC.completion = ^ {
            [[self navigationController] popToRootViewControllerAnimated:YES];
        };
//        loginVC.delegate = self;
    }
}

- (void)logOut {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"LoginViewController" sender:self];
}

- (void)addAdditionalUI {
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = signOutButton;
}

- (void)presentLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = @"Alert!";
    notification.alertBody = @"You've been alerted.";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)testStack {
    self.stack = [[Stack alloc] initWithStack:[@[@""] mutableCopy]];
    NSArray *copy = self.stack.stack;
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.stack addObject:@"One"];
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.stack addObject:@"Two"];
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.stack removeObject];
    NSLog(@"%lu", (unsigned long)copy.count);
}

- (void)testQueue {
    self.queue = [[Queue alloc] initWithQueue:[@[@(0)] mutableCopy]];
    NSArray *copy = self.queue.queue;
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.queue enqueue:@(1)];
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.queue enqueue:@(23)];
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.queue enqueue:@(88)];
    NSLog(@"%lu", (unsigned long)copy.count);
    [self.queue dequeue];
    NSLog(@"%lu", (unsigned long)copy.count);
}

- (void)testAnagram {
    self.anagram = [[Anagram alloc] init];
    BOOL answer = [self.anagram checkForAnagramWithString:@"debit card" checkAgainst:@"bad credit"];
    NSLog(answer ? @"YES" : @"NO");
    BOOL answerTwo = [self.anagram checkForAnagramWithString:@"not close" checkAgainst:@"at all"];
    NSLog(answerTwo ? @"YES" : @"NO");
}

- (IBAction)longPressGestureRecognized:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.locationMapView];
        CLLocationCoordinate2D coordinate = [self.locationMapView convertPoint:point toCoordinateFromView:self.locationMapView];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = @"New Location";
        [self.locationMapView addAnnotation:annotation];
    }
}

- (IBAction)tapGestureRecognized:(UIGestureRecognizer*)sender {
//    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.locationMapView];
        CLLocationCoordinate2D coordinate = [self.locationMapView convertPoint:point toCoordinateFromView:self.locationMapView];
        for (CLCircularRegion *region in self.monitoredRegions) {
            if ([region containsCoordinate:coordinate]) {
                for (Reminder *reminder in self.reminders) {
                    if ([region.identifier isEqualToString:reminder.name]) {
                        [self performSegueWithIdentifier:@"LocationDetailViewController" sender:reminder];
                    }
                }
            }
        }
//    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomLocationPin"];
    annotationView.annotation = annotation;
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomLocationPin"];
    }
    annotationView.canShowCallout = YES;
    UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCallout;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"LocationDetailViewController" sender:view];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithCircle:overlay];
    UIColor *orangeOverlayColor = [UIColor colorWithRed:1.000 green:0.490 blue:0.020 alpha:0.650];
    UIColor *greyOverlayBorderColor = [UIColor colorWithRed:0.549 green:0.510 blue:0.475 alpha:0.650];
    circle.strokeColor = greyOverlayBorderColor;
    circle.fillColor = orangeOverlayColor;
    return circle;
}

#pragma mark - LocationServiceDelegate

- (void)locationServiceDidUpdateLocation:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    [self setRegion:region];
}

//#pragma mark - LoginViewControllerDelegate
//
//- (void)didFinishLoggingIn {
//    [self addAdditionalUI];
//}

@end


