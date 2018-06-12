//
//  PlaceTableViewController.m
//  Aviasales
//
//  Created by Ronin on 19/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "DataManager.h"
#import "NSString+Localize.h"

@interface PlaceTableViewController() <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation PlaceTableViewController

NSArray *currentList;
NSArray *searchList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    currentList = [NSArray new];
    searchList = [NSArray new];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[[@"cities" localize], [@"airports" localize]]];
    [_segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    [_segmentedControl setSelectedSegmentIndex:0];
    [self changeSegment];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = _searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        self.tableView.tableHeaderView = _searchController.searchBar;
    }
}
-(void)changeSegment {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _type = DataSourceTypeCity;
            currentList = [DataManager sharedInstance].cities;
            break;
        case 1:
            _type = DataSourceTypeAirport;
            currentList = [DataManager sharedInstance].airports;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length > 0)
    {
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        searchList = [currentList filteredArrayUsingPredicate: predicate];
        [self.tableView reloadData];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.isActive && searchList.count > 0) {
        return searchList.count;
    }
    return currentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"placeIdentifier"];
    id currentPlace;
    if (_searchController.isActive && searchList.count > 0) {
        currentPlace = searchList[indexPath.row];
    } else {
      currentPlace = currentList[indexPath.row];
    }
    
    switch (_type) {
        case DataSourceTypeCity:
            cell.textLabel.text = ((City*) currentPlace).name;
            cell.detailTextLabel.text = ((City*) currentPlace).code;
            break;
        case DataSourceTypeAirport:
            cell.textLabel.text = ((Airport*) currentPlace).name;
            cell.detailTextLabel.text = ((Airport*) currentPlace).code;
            break;
        default:
            break;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id currentPlace;
    if (_searchController.isActive && searchList.count > 0) {
        currentPlace = searchList[indexPath.row];
    } else {
        currentPlace = currentList[indexPath.row];
    }
    switch (_type) {
        case DataSourceTypeCity:
            [self.delegate selectPlace:(City*) currentPlace withType:_placeType andDataType:_type];
            break;
        case DataSourceTypeAirport:
            [self.delegate selectPlace:(Airport*) currentPlace withType:_placeType andDataType:_type];
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
