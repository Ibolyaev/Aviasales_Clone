//
//  SearchRequest.h
//  Aviasales
//
//  Created by Ronin on 22/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface SearchRequest : NSObject
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSDate *departDate;
@property (strong, nonatomic) NSDate *returnDate;
@end
