//
//  TicketTableViewCell.h
//  Aviasales
//
//  Created by Ronin on 22/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) Ticket *ticket;

@end
