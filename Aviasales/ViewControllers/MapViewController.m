//
//  MapViewController.m
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "MapViewController.h"
#import "Airport.h"
#import "DataManager.h"
#import "APIManager.h"
#import "MapPrice.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController
NSArray<City *> *places;
MKMapView *mapView;
CLLocationManager *locationManager;
CLLocation *currentLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect frame = CGRectMake (0, 0, screenWidth, [UIScreen mainScreen].bounds.size.height);
    mapView = [[MKMapView alloc] initWithFrame: frame];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    locationManager = [[ CLLocationManager alloc] init];
    places = DataManager.sharedInstance.airports;
    [self reloadAnnotations];
}

- (void) reloadAnnotations {
    [mapView removeAnnotations:mapView.annotations];
    for (City *city in places) {
        [self addAnnotationForLocation:city.coordinate withTitle:city.name andSubtitle: city.code];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startUpdatingLocation];
}
- (void) startUpdatingLocation {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter =  500;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}
- (void) addAnnotationForLocation:(CLLocationCoordinate2D) location withTitle: (NSString*) title andSubtitle: (NSString*) subtitle{
    MKPointAnnotation *annotation = [[MKPointAnnotation  alloc] init];
    annotation.title = title;
    annotation.subtitle = subtitle;
    annotation.coordinate = location;
    [mapView addAnnotation:annotation];
}
-(void) setCurrentRegionWithLocation:(CLLocation*) location {
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (coordinate, 1000000, 1000000);
    [mapView setRegion: region animated: YES];
}
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation  *location = [locations firstObject];
    if  (location) {
        currentLocation = location;
        [self setCurrentRegionWithLocation:location];
        [locationManager stopUpdatingLocation];
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    City *city = [[DataManager sharedInstance] cityForIATA:view.annotation.subtitle];
    [[APIManager sharedInstance] mapPricesFor:city withCompletion:^(NSArray *prices) {
        for (MapPrice *mapPrice in prices) {
            [self saveFavoriteTicket:mapPrice];
        }
    }];
}

- (void) saveFavoriteTicket: (MapPrice *) mapPrice {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    NSManagedObject *newFavoriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:context];
    [newFavoriteTicket setValue:mapPrice.destination.code forKey:@"to"];
    [newFavoriteTicket setValue:mapPrice.origin.code forKey:@"from"];
    [newFavoriteTicket setValue:[NSNumber numberWithInteger:mapPrice.value] forKey:@"price"];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
@end
