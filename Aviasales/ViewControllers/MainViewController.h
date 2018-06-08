//
//  MainViewController.h
//  Aviasales
//
//  Created by Ronin on 19/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceTableViewController.h"

@interface MainViewController : UIViewController<PlaceViewControllerDelegate>
@property (nonatomic, strong)  UIView  *placeContainerView;
@property  ( nonatomic ,  strong )  UIButton  *departureButton;
@property  ( nonatomic ,  strong )  UIButton  *arrivalButton;
//@property (nonatomic)  SearchRequest searchRequest;
@property  ( nonatomic ,  strong )  UIButton  *searchButton;
@end
