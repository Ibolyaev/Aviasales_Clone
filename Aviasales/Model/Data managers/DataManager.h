//
//  DataManager.h
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"
#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"
#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];
typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject
+ (instancetype) sharedInstance;
- (void) loadData;
-(City*) cityForIATA:(NSString*) iata;
@property (nonatomic, strong, readonly) NSArray * countries;
@property (nonatomic, strong, readonly) NSArray * cities;
@property (nonatomic, strong, readonly) NSArray * airports;
@end
