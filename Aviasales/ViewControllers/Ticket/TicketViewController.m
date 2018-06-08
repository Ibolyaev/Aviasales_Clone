//
//  TicketViewController.m
//  Aviasales
//
//  Created by Ronin on 25/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "TicketViewController.h"
#import "DataManager.h"
#import <YYWebImage/YYWebImage.h>
#import "NSString+Localize.h"

@interface TicketViewController ()

@end

@implementation TicketViewController {
    BOOL isFavorite;
    FavoriteTicket* favoriteTicket;
    Ticket* ticket;
}

UILabel *priceLabel;
UIImageView *airlineLogoView;
UILabel *placesLabel;
UILabel *priceLabel;
UILabel *dateLabel;
UIView *containerView;
- (instancetype)initFavoriteTicketController:(FavoriteTicket *) favoriteTicket {
    self = [super init];
    if (self) {
        isFavorite = YES;
        self->favoriteTicket = favoriteTicket;
    }
    return self;
}

- (instancetype)initTicketController:(Ticket *)ticket {
    self = [super init];
    if (self)
    {
        self->ticket = ticket;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor ];
    self.navigationController.navigationBar.prefersLargeTitles =  YES;
    self.title = [@"ticket_title" localize];
    UIView * containerView = [self createContainerView];
    
    CGRect airLineLogoFrame = CGRectMake(10, 10, 80, 80);
    airlineLogoView = [[UIImageView alloc] initWithFrame:airLineLogoFrame];
    airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:airlineLogoView];
    
    CGRect priceFrame = CGRectMake(10 , CGRectGetMaxY(airlineLogoView.frame), containerView.bounds.size.width, 40);
    priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
    priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [containerView addSubview:priceLabel];
    
    CGRect placesFrame = CGRectMake(10.0, CGRectGetMaxY(priceLabel.frame) + 16.0, 100.0, 20.0);
    placesLabel = [[UILabel alloc] initWithFrame:placesFrame];
    placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    placesLabel.textColor = [UIColor darkGrayColor];
    [containerView addSubview:placesLabel];
    
    CGRect dateFrame = CGRectMake(10.0, CGRectGetMaxY(placesLabel.frame) + 8.0, containerView.frame.size.width - 20.0, 20.0);
    dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [containerView addSubview:dateLabel];
    
    [self.view addSubview: containerView];    
    [self updateUI];
}

- (UIView *)createContainerView {
    UIView *containerView = [[UIView alloc] initWithFrame: CGRectMake (20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, [UIScreen mainScreen].bounds.size.height -200.0 )];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent: 0.1]
                                       CGColor];
    containerView.layer.shadowOffset = CGSizeZero;
    containerView.layer.shadowRadius = 20.0;
    containerView.layer.shadowOpacity = 1.0;
    containerView.layer.cornerRadius = 6.0;
    return containerView;
}

- (void) updateUI {
    
    priceLabel.text = [NSString stringWithFormat:@"%@ руб.", isFavorite? [NSNumber numberWithDouble:favoriteTicket.price]: ticket.price];
    placesLabel.text = [NSString stringWithFormat:@"%@ - %@", isFavorite? favoriteTicket.from: ticket.from, isFavorite? favoriteTicket.to : ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    dateLabel.text = [dateFormatter stringFromDate:isFavorite? favoriteTicket.departure : ticket.departure];
    NSURL *urlLogo = AirlineLogo(isFavorite? favoriteTicket.airline : ticket.airline);
    [airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
