//
//  TicketsTableViewController.m
//  Aviasales
//
//  Created by Ronin on 22/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "TicketsTableViewController.h"
#import "APIManager.h"
#import "TicketViewController.h"
#import "TicketTableViewCell.h"
@import UserNotifications;
#import "AppDelegate.h"
#import "NSString+Localize.h"
#import "CoreDataHelper.h"

@interface TicketsTableViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@end

@implementation TicketsTableViewController {
    BOOL isFavorites;
    TicketTableViewCell *notificationCell;
}
- (NSManagedObjectContext *)managedObjectContext
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    return context;
}
UNUserNotificationCenter *center;
- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSArray new];
        self.title = [@"favorites_tab" localize];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:TicketTableViewCell.self forCellReuseIdentifier:@"ticketIdentifier"];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        self.tickets = tickets;
        self.title = [@"tickets_title" localize];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:TicketTableViewCell.self forCellReuseIdentifier:@"ticketIdentifier"];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (isFavorites) {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteTicket"];
        self.tickets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        [self.tableView reloadData];
    }
}
- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && notificationCell) {
        
        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
                
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        NSError *error;
        UNNotificationAttachment *icon = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageURL options:nil error:&error];
        if (error)
        {
            NSLog(@"error while storing image attachment in notification: %@", error);
        }
        [self sendNotificationWithTicket:notificationCell.ticket and:@[icon] at: _datePicker.date];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}
- (void) sendNotificationWithTicket: (Ticket*) ticket and: (NSArray<UNNotificationAttachment *>*) attachments at: (NSDate*) date {
    center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert ;
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", ticket.from, ticket.to, ticket.price];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = [@"notification_title" localize];
    content.body = message;
    NSData *ticketData = [NSKeyedArchiver archivedDataWithRootObject:ticket];
    content.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:ticketData, @"Ticket", nil];
    content.attachments = attachments;
    
    NSDateComponents *components = [NSCalendar.currentCalendar components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents: components repeats:NO];
    NSString *identifier = @"UYLLocalNotification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeTranslation(0.f, 140);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketIdentifier" forIndexPath:indexPath];
    if (isFavorites) {
       cell.favoriteTicket = _tickets[indexPath.row];
    } else {
        cell.ticket = _tickets[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) {
        TicketViewController *ticketVC = [[TicketViewController alloc] initFavoriteTicketController:_tickets[indexPath.row]];
        [self.navigationController pushViewController:ticketVC animated:YES];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"actions_with_tickets" localize] message:[@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:[@"remove_from_favorite" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:_tickets[indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:[@"add_to_favorite" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:_tickets[indexPath.row]];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:[@"notify_me" localize] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [_dateTextField becomeFirstResponder];
    }];
    UIAlertAction *openTicketAction = [UIAlertAction actionWithTitle:[@"open_ticket" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TicketViewController *ticketVC = [[TicketViewController alloc] initTicketController:_tickets[indexPath.row]];
        [self.navigationController pushViewController:ticketVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:openTicketAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
