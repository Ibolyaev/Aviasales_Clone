//
//  APIManager.h
//  Aviasales
//
//  Created by Ronin on 21/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "SearchRequest.h"

@interface APIManager : NSObject
+ ( instancetype )sharedInstance;
- (void) cityForCurrentIP:(void  (^)( City *city) ) completion;
- (void) mapPricesFor:(City *)origin withCompletion:(void (^)( NSArray  *prices)) completion;
- (void) ticketsWithRequest:(SearchRequest*) request withCompletion:(void (^)(NSArray *tickets))completion;
@end
