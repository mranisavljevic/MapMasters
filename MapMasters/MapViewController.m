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
#import "Stack.h"
#import "Queue.h"
#import "Anagram.h"
@import MapKit;
@import CoreLocation;
@import Parse;
@import ParseUI;

@interface MapViewController () <LocationServiceDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selimiyeLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *mehmedPasaLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *suleymaniyeLocationButton;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
- (IBAction)locationButtonPressed:(id)sender;
- (IBAction)longPressGestureRecognized:(id)sender;
//@property PFLogInViewController *loginVC;
//@property PFSignUpViewController *signUpVC;
@property Stack *stack;
@property Queue *queue;
@property Anagram *anagram;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self logIn];
//    [self testStack];
//    [self testQueue];
//    [self testAnagram];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [[LocationService sharedService] setDelegate:self];
    [[LocationService sharedService]setMapView:self.locationMapView];
    [[[LocationService sharedService] locationManager] startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[[LocationService sharedService] locationManager] stopUpdatingLocation];
}

- (void)setUpView {
    
    UIColor *salmonColor = [UIColor colorWithRed:1.000 green:0.733 blue:0.553 alpha:1.000];
    UIColor *darkBrownColor = [UIColor colorWithRed:0.435 green:0.275 blue:0.200 alpha:1.000];
    self.locationMapView.mapType = MKMapTypeSatellite;
    self.locationMapView.layer.cornerRadius = 15.0;
    self.locationMapView.layer.borderColor = [darkBrownColor CGColor];
    self.locationMapView.layer.borderWidth = 1.0;
    self.selimiyeLocationButton.backgroundColor = salmonColor;
    self.mehmedPasaLocationButton.backgroundColor = salmonColor;
    self.suleymaniyeLocationButton.backgroundColor = salmonColor;
    self.selimiyeLocationButton.layer.cornerRadius = 5.0;
    self.mehmedPasaLocationButton.layer.cornerRadius = 5.0;
    self.suleymaniyeLocationButton.layer.cornerRadius = 5.0;
    self.selimiyeLocationButton.layer.borderColor = [darkBrownColor CGColor];
    self.mehmedPasaLocationButton.layer.borderColor = [darkBrownColor CGColor];
    self.suleymaniyeLocationButton.layer.borderColor = [darkBrownColor CGColor];
    self.selimiyeLocationButton.layer.borderWidth = 1.0;
    self.mehmedPasaLocationButton.layer.borderWidth = 1.0;
    self.suleymaniyeLocationButton.layer.borderWidth = 1.0;
}

- (void)setRegion: (MKCoordinateRegion)region {
    [self.locationMapView setRegion:region animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LocationDetailViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[LocationDetailViewController class]]) {
            LocationDetailViewController *detailVC = (LocationDetailViewController *)segue.destinationViewController;
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            detailVC.coordinate = annotationView.annotation.coordinate;
            detailVC.annotationTitle = annotationView.annotation.title;
            __weak typeof(self) weakSelf = self;
            detailVC.completion = ^(MKCircle *circle) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.locationMapView removeAnnotation:annotationView.annotation];
                [strongSelf.locationMapView addOverlay:circle];
            };
        }
    }
}

- (void)logIn {
    if (![PFUser currentUser]) {
        PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
        logInVC.delegate = self;
        PFSignUpViewController *signUpVC = [[PFSignUpViewController alloc] init];
        signUpVC.delegate = self;
        logInVC.signUpController = signUpVC;
        [self presentViewController:logInVC animated:YES completion:nil];
    } else {
        [self addAdditionalUI];
    }
}

- (void)logOut {
    [PFUser logOut];
    [self logIn];
}

- (void)addAdditionalUI {
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
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

- (IBAction)locationButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = sender;
        NSString *buttonTitle = button.titleLabel.text;
        if ([buttonTitle isEqualToString:@"Selimiye Mosque"]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.678326, 26.559207);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 600.0, 600.0);
            [self setRegion:region];
        }
        if ([buttonTitle isEqualToString:@"Mehmed Paša Sokolović Bridge"]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(43.782611, 19.287983);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 600.0, 600.0);
            [self setRegion:region];
        }
        if ([buttonTitle isEqualToString:@"Süleymaniye Mosque"]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.016090, 28.964054);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 600.0, 600.0);
            [self setRegion:region];
        }
    }
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
    UIColor *orangeOverlayColor = [UIColor colorWithRed:1.000 green:0.490 blue:0.020 alpha:0.500];
    UIColor *greyOverlayBorderColor = [UIColor colorWithRed:0.549 green:0.510 blue:0.475 alpha:0.500];
    circle.strokeColor = greyOverlayBorderColor;
    circle.fillColor = orangeOverlayColor;
    return circle;
}

#pragma mark - LocationServiceDelegate

- (void)locationServiceDidUpdateLocation:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    [self setRegion:region];
}

#pragma mark - PFUserLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self addAdditionalUI];
}

#pragma mark - PFUserSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self addAdditionalUI];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


