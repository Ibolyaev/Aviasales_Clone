//
//  APIManager.m
//  Aviasales
//
//  Created by Ronin on 21/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "APIManager.h"
#import "DataManager.h"
#import "Ticket.h"
#import "MapPrice.h"
#import "SearchRequest.h"

#define API_TOKEN @"0b4689974a57562005b394a0bd26a121"
#define API_URL_IP_ADDRESS @ "https://api.ipify.org/?format=json"
#define API_URL_CHEAP @ "https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @ "https://www.travelpayouts.com/whereami?ip="
#define API_URL_MAP_PRICE @ "https://map.aviasales.ru/prices.json?origin_iata="

@implementation APIManager
+ (instancetype )sharedInstance {
    static   APIManager  *instance;
    static   dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
    instance = [[ APIManager   alloc ]  init];
    });
  return  instance;
}
- ( void )mapPricesFor:(City *)origin withCompletion:( void  (^)( NSArray  *prices)) completion {
    static  BOOL  isLoading;
    if (isLoading) {
        return ;
    }
    isLoading = YES;
    [self load:[NSString stringWithFormat: @"%@%@" , API_URL_MAP_PRICE, origin.code] withCompletion:^( id  _Nullable result) {
        NSMutableArray *prices = [NSMutableArray new];
        if ((NSDictionary*) result[@"errors"] != nil) {
            NSLog(@"%@",(NSDictionary*) result[@"errors"]);
            dispatch_async (dispatch_get_main_queue(), ^{
                completion(prices); });
            return;
        }
        NSArray *array = result;
        
        if (array) {
            for (NSDictionary  *mapPriceDictionary  in  array) {                
                MapPrice *mapPrice = [[MapPrice alloc] initWithDictionary:mapPriceDictionary withOrigin:origin];
                [prices addObject:mapPrice];
            }
            isLoading = NO ;
            dispatch_async (dispatch_get_main_queue(), ^{
                completion(prices); });
        } }];
}
NSString *SearchRequestQuery(SearchRequest*  request) {
    NSString *result = [NSString stringWithFormat : @"origin=%@&destination=%@", request.origin,
                        request.destination];
    if (request.departDate && request.returnDate ) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
        dateFormatter.dateFormat =  @"yyyy-MM";
        result = [NSString stringWithFormat: @"%@&depart_date=%@&return_date=%@" , result, [dateFormatter  stringFromDate :request.departDate ], [dateFormatter stringFromDate: request.returnDate ]];
    }
    return result;
}
- (void) ticketsWithRequest:(SearchRequest*) request withCompletion:(void (^)(NSArray *tickets))completion {
    NSString *urlString = [NSString stringWithFormat : @"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery (request), API_TOKEN];
    [self load :urlString withCompletion :^(id _Nullable result) {  NSDictionary  *response = result;
        if (response) {
            NSDictionary  *jsonData = [response  valueForKey: @"data"];
            NSDictionary  *json = [jsonData valueForKey :request.destination];
            NSMutableArray  *array = [ NSMutableArray new ];
            if ([json respondsToSelector:@selector(count)]) {
                for (NSString *key in json) {
                    NSDictionary  *value = [json  valueForKey : key];
                    Ticket  *ticket = [[ Ticket alloc ] initWithDictionary :value]; ticket.from = request. origin ;
                    ticket.to = request. destination ;
                    [array addObject :ticket];
                }
            }
            dispatch_async ( dispatch_get_main_queue (), ^{ completion(array);
            });
        }
    }];
}
- ( void )cityForCurrentIP:( void  (^)( City *city))completion {
    [self IPAddressWithCompletion :^( NSString  *ipAddress) {
    [self load :[ NSString stringWithFormat : @"%@%@" , API_URL_CITY_FROM_IP, ipAddress] withCompletion :^( id   _Nullable  result) {
        NSDictionary  *json = result;
        NSString  *iata = [json  valueForKey:   @"iata" ];  if  (iata) {
            City  *city = [[ DataManager   sharedInstance ]  cityForIATA :iata];
            if  (city) {
                dispatch_async ( dispatch_get_main_queue (), ^{ completion(city);
                });
            }
        } }];
}]; }

- ( void )IPAddressWithCompletion:( void (^)( NSString  *ipAddress))completion { [ self load: API_URL_IP_ADDRESS  withCompletion :^( id _Nullable result) {
    NSDictionary  *json = result;
    completion([json valueForKey :@  "ip" ]);}];
}

- (void) load: (NSString*) urlString withCompletion: (void (^) (id _Nullable result)) completion {
    dispatch_async (dispatch_get_main_queue(), ^{ [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible :YES] ;});
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async (dispatch_get_main_queue(), ^{ [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible :NO] ;});
        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
    }];
    
    [task resume];

}
@end
