//
//  CoreDataHelper.h
//  Aviasales
//
//  Created by Ronin on 02/06/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface CoreDataHelper : NSObject
+ (instancetype)sharedInstance;
-(void) addToFavorite: (Ticket*) ticket;
-(void) removeFromFavorite: (Ticket*) ticket;
-(BOOL) isFavorite: (Ticket*) ticket;
@end
