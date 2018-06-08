//
//  Ticket.m
//  Aviasales
//
//  Created by Ronin on 21/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket
- (instancetype)initWithDictionary:( NSDictionary  *)dictionary {
    self = [super init];
    if (self) {
        _airline  = [dictionary  valueForKey :@"airline" ];
        _expires  =  dateFromString ([dictionary  valueForKey : @"expires_at" ]);
        _departure  =  dateFromString ([dictionary valueForKey : @"departure_at" ]);
        _flightNumber  = [dictionary  valueForKey : @"flight_number"];
        _price  = [dictionary  valueForKey :@"price"];
        _returnDate  =  dateFromString ([dictionary  valueForKey : @"return_at"]);        
    }
    return self;
}
NSDate *dateFromString( NSString  *dateString) {
    if (!dateString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[ NSDateFormatter alloc ] init];
    NSString *correctSrtingDate = [dateString  stringByReplacingOccurrencesOfString : @"T"   withString : @" "];
    correctSrtingDate = [correctSrtingDate  stringByReplacingOccurrencesOfString : @"Z"  withString : @" "];
    dateFormatter. dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter  dateFromString : correctSrtingDate];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.airline forKey:@"airline"];
    [aCoder encodeObject:self.expires forKey:@"expires"];
    [aCoder encodeObject:self.departure forKey:@"departure"];
    [aCoder encodeObject:self.flightNumber forKey:@"flightNumber"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.from forKey:@"from"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.returnDate forKey:@"returnDate"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.airline = [aDecoder decodeObjectForKey:@"airline"];
    self.expires = [aDecoder decodeObjectForKey:@"expires"];
    self.departure = [aDecoder decodeObjectForKey:@"departure"];
    self.flightNumber = [aDecoder decodeObjectForKey:@"flightNumber"];
    self.price = [aDecoder decodeObjectForKey:@"price"];
    self.from = [aDecoder decodeObjectForKey:@"from"];
    self.to = [aDecoder decodeObjectForKey:@"to"];
    self.returnDate = [aDecoder decodeObjectForKey:@"returnDate"];
    return self;
}

@end
