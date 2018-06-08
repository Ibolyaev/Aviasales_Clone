//
//  FavoriteTicket+CoreDataProperties.m
//  
//
//  Created by kuzindmitry on 08.11.2017.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FavoriteTicket"];
}

@dynamic price;
@dynamic airline;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic returnDate;
@dynamic from;
@dynamic to;
@dynamic created;

@end
