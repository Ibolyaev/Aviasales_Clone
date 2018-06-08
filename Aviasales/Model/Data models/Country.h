//
//  Country.h
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * currency;
@property (nonatomic, strong) NSDictionary * translations;
@property (nonatomic, strong) NSString * code;

- (instancetype) initWithDictionary:( NSDictionary * )dictionary;

@end
