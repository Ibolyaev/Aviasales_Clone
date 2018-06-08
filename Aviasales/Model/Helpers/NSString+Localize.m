//
//  NSString+Localize.m
//  air
//
//  Created by kuzindmitry on 09.11.2017.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end
