//
//  City.m
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype) initWithDictionary:( NSDictionary * ) dictionary {
    self = [super init];
    if (self) {
        _timezone  = [dictionary  valueForKey: @"time_zone"];
        _translations  = [dictionary  valueForKey:@  "name_translations"] ;
        _name  = [dictionary  valueForKey: @"name"] ;
        _countryCode  = [dictionary  valueForKey: @"country_code"] ;
        _code  = [dictionary  valueForKey: @"code"] ;
        NSDictionary * coords  = [dictionary  valueForKey: @"coordinates"] ;
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber * lon = [coords valueForKey: @"lon"];
            NSNumber * lat = [coords valueForKey: @"lat"];
            if (![lon isEqual:[ NSNull null]] && ![lat isEqual:[ NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [ lon doubleValue]);
            }
            if ([_name  isEqual: @"Moscow"]) {
                NSLog(@"Moscow");
            }
        }
        [self localizeName];
    }
    return self;
}
- (void)localizeName {
    if (!_translations) return;
    NSLocale *locale = [NSLocale currentLocale];
    NSString *localeId = [locale.localeIdentifier substringToIndex:2];
    if (localeId) {
        if ([_translations valueForKey: localeId]) {
            self.name = [_translations valueForKey: localeId];
        }
    }
}

@end
