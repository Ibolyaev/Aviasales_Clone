//
//  MainTabBarController.m
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsTableViewController.h"
#import "NSString+Localize.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewControllers = [self createViewControllers];
    }
    return self;
}

- (NSArray <UIViewController *> *)createViewControllers {
    NSMutableArray <UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.view.backgroundColor = UIColor.whiteColor;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    navigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"tickets_tab" localize] image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    
    MapViewController *secondVC = [[MapViewController alloc] init];
    secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"price_map_tab" localize] image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
   
    TicketsTableViewController *favoriteTicketsVC = [[TicketsTableViewController alloc] initFavoriteTicketsController];
    UINavigationController *navigationFavoriteTickets = [[UINavigationController alloc] initWithRootViewController:favoriteTicketsVC];
    navigationFavoriteTickets.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"favorites_tab" localize] image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    
    [controllers addObject:navigationVC];
    [controllers addObject:secondVC];
    [controllers addObject:navigationFavoriteTickets];
    return controllers;
}

@end
