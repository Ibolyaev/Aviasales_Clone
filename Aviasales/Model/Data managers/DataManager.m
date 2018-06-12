//
//  DataManager.m
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "DataManager.h"
@interface  DataManager ()
@property (nonatomic, strong)   NSMutableArray * countriesArray;
@property (nonatomic, strong)   NSMutableArray * citiesArray;
@property (nonatomic, strong)   NSMutableArray * airportsArray;
@end

@implementation DataManager
+ (instancetype) sharedInstance {
    static DataManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ { instance = [[DataManager alloc] init];
    });
    return instance;
}
- (NSArray*)countries {
    return  _countriesArray;
}
- (NSArray*)cities {
    return  _citiesArray;
}
- (NSArray*)airports {
    return  _airportsArray;
}
-(NSArray*) arrayFromFileName: (NSString*) fileName ofType: (NSString*) type {
    NSString *path = [[NSBundle  mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: nil] ;
}
- (City*) cityForIATA:(NSString*) iata {
    if  (iata) {
        for  (City  *city  in _citiesArray ) {
            if ([city. code isEqualToString :iata]) {
                return  city;
            }
        }
    }
    return nil;
}
-(NSMutableArray*) createObjectsFromArray: (NSArray*)array withType: (DataSourceType) type {
    NSMutableArray *arrayOfObjects = [[NSMutableArray alloc] init];
    switch (type) {
        case DataSourceTypeCountry:
            for (NSDictionary *dict in array) {
                [arrayOfObjects addObject:[[Country alloc] initWithDictionary:dict]];
            }
            break;
        case DataSourceTypeCity:
            for (NSDictionary *dict in array) {
                [arrayOfObjects addObject:[[City alloc] initWithDictionary:dict]];
            }
            break;
        case DataSourceTypeAirport:
            for (NSDictionary *dict in array) {
                [arrayOfObjects addObject:[[Airport alloc] initWithDictionary:dict]];
            }
            break;
    }
    return arrayOfObjects;
}

- (void) loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^ {
        NSArray * countriesJsonArray  = [self arrayFromFileName: @"countries" ofType: @"json"] ;
        _countriesArray  = [self createObjectsFromArray:countriesJsonArray withType: DataSourceTypeCountry];
        NSArray * citiesJsonArray = [self arrayFromFileName: @"cities" ofType: @"json"] ;
        _citiesArray  = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];        
        NSArray * airportsJsonArray = [self arrayFromFileName: @"airports" ofType: @"json"] ;
        _airportsArray  = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        dispatch_async( dispatch_get_main_queue(), ^ {[[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object: nil];
        });
        NSLog(  @"Complete load data") ;
    } );
}
@end
