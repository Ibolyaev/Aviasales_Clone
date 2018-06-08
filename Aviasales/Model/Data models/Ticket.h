//
//  Ticket.h
//  Aviasales
//
//  Created by Ronin on 21/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject <NSSecureCoding>
@property (nonatomic , strong )  NSNumber  *price;
@property (nonatomic , strong )  NSString  *airline;
@property (nonatomic , strong )  NSDate  *departure;
@property (nonatomic , strong )  NSDate  *expires;
@property (nonatomic , strong )  NSNumber  *flightNumber;
@property (nonatomic , strong )  NSDate  *returnDate;
@property (nonatomic , strong )  NSString  *from;
@property (nonatomic , strong )  NSString  *to;
@property (class, readonly) BOOL supportsSecureCoding;
- ( instancetype )initWithDictionary:( NSDictionary  *)dictionary;
@end
