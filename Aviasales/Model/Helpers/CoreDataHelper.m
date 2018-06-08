//
//  CoreDataHelper.m
//  Aviasales
//
//  Created by Ronin on 02/06/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "FavoriteTicket+CoreDataClass.h"

@implementation CoreDataHelper
+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
    });
    return instance;
}
- (NSManagedObjectContext *)managedObjectContext
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    return context;
}
-(void) addToFavorite: (Ticket*) ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save];
}
-(void) removeFromFavorite: (Ticket*) ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [self.managedObjectContext deleteObject:favorite];
        [self save];
    }
}
-(BOOL) isFavorite: (Ticket*) ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

-(void) save {
    NSError *error;
    [self.managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

@end
