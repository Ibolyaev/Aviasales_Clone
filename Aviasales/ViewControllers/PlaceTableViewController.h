//
//  PlaceTableViewController.h
//  Aviasales
//
//  Created by Ronin on 19/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;
@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end
@interface PlaceTableViewController : UITableViewController

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic) DataSourceType type;
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
@end
