//
//  TicketViewController.h
//  Aviasales
//
//  Created by Ronin on 25/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "FavoriteTicket+CoreDataProperties.h"

@interface TicketViewController : UIViewController
- (instancetype)initTicketController:(Ticket *)ticket;
- (instancetype)initFavoriteTicketController:(FavoriteTicket *) favoriteTicket;
@end
