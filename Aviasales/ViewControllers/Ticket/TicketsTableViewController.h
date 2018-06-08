//
//  TicketsTableViewController.h
//  Aviasales
//
//  Created by Ronin on 22/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "SearchRequest.h"

@interface TicketsTableViewController : UITableViewController
- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;
@end
