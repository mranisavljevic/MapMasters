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
@import MapKit;
@import CoreLocation;

@interface MapViewController ()

@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
- (IBAction)locationButtonPressed:(id)sender;
@property Stack *stack;
@property Queue *queue;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLocationPermission];
    [self.locationMapView setShowsUserLocation:YES];
    self.locationMapView.mapType = MKMapTypeSatellite;
    self.locationMapView.layer.cornerRadius = 15.0;
    [self testStack];
    [self testQueue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestLocationPermission {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)setRegion: (MKCoordinateRegion)region {
    [self.locationMapView setRegion:region animated:YES];
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
@end


