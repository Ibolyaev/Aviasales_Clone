//
//  MainViewController.m
//  Aviasales
//
//  Created by Ronin on 19/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "MainViewController.h"
#import "PlaceTableViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "TicketsTableViewController.h"
#import "NSString+Localize.h"
#import "ProgressView.h"

@interface MainViewController ()

@end

@implementation MainViewController

SearchRequest *searchRequest;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor ];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = [@"main_vc_title" localize];
    
    searchRequest = [[SearchRequest alloc] init];
    
    [self createPlaceContainerView];
    [self createDepartureButton];
    [self createArrivalButton];
    [self.placeContainerView addSubview : _departureButton];
    [self.placeContainerView addSubview : _arrivalButton ];
    [self.view addSubview : _placeContainerView ];
    [self createSearchButton];
    [self.view addSubview : _searchButton];
    [DataManager.sharedInstance loadData];
    [[NSNotificationCenter defaultCenter] addObserver :self selector :@selector(dataLoadedSuccessfully) name: kDataManagerLoadDataDidComplete object :nil];
}
- (void)createPlaceContainerView {
    _placeContainerView = [[UIView alloc] initWithFrame: CGRectMake (20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    _placeContainerView.backgroundColor = [UIColor whiteColor];
    _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent: 0.1]
                                             CGColor];
    _placeContainerView.layer.shadowOffset  = CGSizeZero;
    _placeContainerView.layer.shadowRadius  = 20.0;
    _placeContainerView.layer.shadowOpacity = 1.0;
    _placeContainerView.layer.cornerRadius  = 6.0;
}

- (void)createDepartureButton {
    _departureButton  = [UIButton buttonWithType: UIButtonTypeSystem];
    [_departureButton setTitle : [@"origin_button_title" localize] forState : UIControlStateNormal];
    _departureButton.tintColor  = [UIColor  blackColor ];
    _departureButton.frame = CGRectMake (10.0, 20.0,  _placeContainerView.frame.size.width - 20.0 , 60.0 );
    _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent : 0.1 ];
    _departureButton.layer.cornerRadius = 4.0;
    [_departureButton addTarget : self action: @selector (placeButtonDidTap:) forControlEvents : UIControlEventTouchUpInside ];
}

- (void)createArrivalButton {
    _arrivalButton  = [UIButton  buttonWithType : UIButtonTypeSystem];
    [_arrivalButton setTitle: [@"arrival_button_title" localize]  forState : UIControlStateNormal ];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake ( 10.0 , CGRectGetMaxY (_departureButton.frame ) +  10.0 , _placeContainerView . frame . size . width  -  20.0,   60.0 );
    _arrivalButton.backgroundColor  = [[UIColor lightGrayColor ] colorWithAlphaComponent : 0.1 ];
    _arrivalButton.layer.cornerRadius  =  4.0 ;
    [_arrivalButton addTarget : self  action : @selector (placeButtonDidTap:) forControlEvents : UIControlEventTouchUpInside ];
}

- (void)createSearchButton {
    _searchButton  = [UIButton buttonWithType: UIButtonTypeSystem ];
    [_searchButton setTitle : [@"find_button" localize] forState : UIControlStateNormal ];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake ( 30.0 , CGRectGetMaxY (_placeContainerView.frame ) +  30 , [ UIScreen mainScreen].bounds.size.width - 60.0, 60.0) ;
    _searchButton.backgroundColor  = [UIColor  blackColor ];
    _searchButton.layer.cornerRadius  =  8.0 ;
    _searchButton.titleLabel.font  = [UIFont  systemFontOfSize : 20.0 weight : UIFontWeightBold];
    [_searchButton addTarget:self action:@selector(searchTickets) forControlEvents:UIControlEventTouchUpInside];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceTableViewController *placeVC;
    if ([sender isEqual:_departureButton]) {
        placeVC = [[PlaceTableViewController alloc] init];
        placeVC.placeType = PlaceTypeDeparture;
    } else {
        placeVC = [[PlaceTableViewController alloc] init];
        placeVC.placeType = PlaceTypeArrival;
    }
    placeVC.delegate = self;
    placeVC.type = DataSourceTypeCity;
    [self.navigationController pushViewController: placeVC animated:YES];
}

- (void) changeToDetailViewController:( UIButton * )sender {
    PlaceTableViewController *placeVC = [[PlaceTableViewController alloc] init];
    placeVC.type = DataSourceTypeCity;
    [self.navigationController pushViewController:placeVC animated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self name :kDataManagerLoadDataDidComplete
                                                     object: nil];
}

-(void) selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        searchRequest.origin = iata;
    } else {
        searchRequest.destination = iata;
    }
    [button setTitle: title forState: UIControlStateNormal];
    
}
- (void) searchTickets {
    if (searchRequest.origin && searchRequest.destination) {
        [[ProgressView sharedInstance] show:^{
            APIManager *api = [APIManager sharedInstance];
            [api ticketsWithRequest:searchRequest withCompletion:^(NSArray *tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TicketsTableViewController *ticketsVC = [[TicketsTableViewController alloc] initWithTickets:tickets];
                        [self.navigationController pushViewController:ticketsVC animated:YES];
                    });
                }];
            }];
        }];        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"error" localize] message:[@"not_set_place_arrival_or_departure" localize] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[@"close" localize] style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}
- ( void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP :^( City *city) {
        [_departureButton setTitle:city.name forState:UIControlStateNormal];
        [ self  setPlace :city  withDataType : DataSourceTypeCity  andPlaceType : PlaceTypeDeparture forButton : _departureButton ];
    }];
}
@end
