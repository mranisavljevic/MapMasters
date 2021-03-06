//
//  MapViewController.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "MapViewController.h"
#import "Stack.h"
#import "Queue.h"
#import "Anagram.h"
#import "SumNumbersInString.h"
#import "LinkedListNode.h"
#import "LinkedListMain.h"

@interface MapViewController () <LocationServiceDelegate, MKMapViewDelegate, WCSessionDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (strong, nonatomic) NSArray *reminders;
- (IBAction)longPressGestureRecognized:(id)sender;
- (IBAction)tapGestureRecognized:(id)sender;
@property (strong, nonatomic) NSArray *monitoredRegions;
@property (strong, nonatomic) NSArray *monitoredOverlays;
@property WCSession *sharedSession;
@property Stack *stack;
@property Queue *queue;
@property Anagram *anagram;
@property SumNumbersInString *sumNums;
@property LinkedListMain *linkedList;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WCSession isSupported]) {
        self.sharedSession = [WCSession defaultSession];
        self.sharedSession.delegate = self;
        [self.sharedSession activateSession];
    }
    [self setUpView];
//    [self testStack];
//    [self testQueue];
//    [self testAnagram];
//    [self testSumNumbersInString];
//    [self testLinkedList];
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
    
//    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    self.locationMapView.mapType = MKMapTypeSatellite;
    self.locationMapView.layer.cornerRadius = 15.0;
    self.locationMapView.layer.borderColor = [[UIColor darkBrownColor] CGColor];
    self.locationMapView.layer.borderWidth = 1.0;
    
    [self.navigationController navigationBar].tintColor = [UIColor darkBrownColor];
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
    [query whereKey:@"enabled" equalTo:[NSNumber numberWithBool:YES]];
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
            [self sendRemindersToWatchExtension:self.reminders];
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
                __weak typeof(self) weakSelf = self;
                detailVC.completion = ^(MKCircle *circle) {
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf.locationMapView addOverlay:circle];
                };
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

- (void)testSumNumbersInString {
    self.sumNums = [[SumNumbersInString alloc] init];
    NSString *stringToTest = @"sdoi897sflj39LS9DH8dkjh38298";
    NSLog(@"%@",[self.sumNums sumNumbersInString:stringToTest]);
}

- (void)testLinkedList {
    self.linkedList = [[LinkedListMain alloc] init];
    LinkedListNode *nodeOne = [[LinkedListNode alloc] initWithValue:@"abc"];
    LinkedListNode *nodeTwo = [[LinkedListNode alloc] initWithValue:@"def"];
    LinkedListNode *nodeThree = [[LinkedListNode alloc] initWithValue:@"ghi"];
    LinkedListNode *nodeFour = [[LinkedListNode alloc] initWithValue:@"jkl"];
    LinkedListNode *nodeFive = [[LinkedListNode alloc] initWithValue:@"mno"];
    [self.linkedList addNode:nodeOne];
    [self.linkedList addNode:nodeTwo];
    [self.linkedList addNode:nodeThree];
    [self.linkedList addNode:nodeFour];
    [self.linkedList addNode:nodeFive];
    NSLog(@"%@", [self.linkedList removeNode]);
    NSLog(@"%@", [self.linkedList removeNode]);
    NSLog(@"%@", [self.linkedList removeNode]);
    NSLog(@"%@", [self.linkedList removeNode]);
    NSLog(@"%@", [self.linkedList removeNode]);
    
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
}

- (void)removeAnnotation:(MKAnnotationView*)annotationView {
    [self.locationMapView removeAnnotation:annotationView.annotation];
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
    annotationView.animatesDrop = YES;
    annotationView.pinTintColor = [UIColor orangePinColor];
    UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    rightCallout.tintColor = [UIColor darkBrownColor];
    annotationView.rightCalloutAccessoryView = rightCallout;
    UIButton *leftClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftClose setTitle:@"ⓧ" forState:UIControlStateNormal];
    [leftClose.titleLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    leftClose.frame = rightCallout.frame;
    leftClose.tintColor = [UIColor darkBrownColor];
    annotationView.leftCalloutAccessoryView = leftClose;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UIButton *button = (UIButton*)control;
    if ([button.titleLabel.text isEqualToString:@"ⓧ"]) {
        [self removeAnnotation:view];
    } else {
        [self performSegueWithIdentifier:@"LocationDetailViewController" sender:view];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circle.strokeColor = [UIColor greyOverlayBorderColor];
    circle.fillColor = [UIColor orangeOverlayColor];
    return circle;
}

#pragma mark - LocationServiceDelegate

- (void)locationServiceDidUpdateLocation:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    [self setRegion:region];
}

#pragma mark = WCSessionDelegate

- (void)sendRemindersToWatchExtension:(NSArray *)reminders {
    NSDictionary *reminderDictionary = @{};
    NSMutableArray *reminderArray = [[NSMutableArray alloc] init];
    for (Reminder *reminder in reminders) {
        NSString *title = reminder.name;
        NSString *radius = [NSString stringWithFormat:@"%f",reminder.radius];
        NSDictionary *coordinate = @{@"latitude":[NSString stringWithFormat:@"%f",reminder.location.latitude],@"longitude":[NSString stringWithFormat:@"%f",reminder.location.longitude]};
        NSDictionary *tempReminderDictionary = @{@"title":title,@"radius":radius,@"coordinate":coordinate};
//        reminderArray = [NSArray arrayWithObject:tempReminderDictionary];
        [reminderArray addObject:tempReminderDictionary];
    }
    reminderDictionary = [NSDictionary dictionaryWithObject:reminderArray forKey:@"reminders"];
    [self.sharedSession updateApplicationContext:reminderDictionary error:nil];
}

@end
