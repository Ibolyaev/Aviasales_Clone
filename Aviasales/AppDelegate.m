//
//  AppDelegate.m
//  Aviasales
//
//  Created by Ronin on 18/05/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Ticket.h"
#import "TicketViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MainTabBarController *mainTabBarVC = [[MainTabBarController alloc] init];
    CGRect windowBounds = [UIScreen mainScreen].bounds;
    UIWindow *window = [[UIWindow alloc] initWithFrame:windowBounds];
    self.window = window;
    window.rootViewController = mainTabBarVC;
    [window makeKeyAndVisible];
    [UIApplication.sharedApplication registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    return YES;
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [self openTicketFromNOtification:notification];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {    
    [self openTicketFromNOtification:response.notification];
}

-(void) openTicketFromNOtification: (UNNotification *)notification {
    NSData *ticketData = [notification.request.content.userInfo valueForKey:@"Ticket"];
    Ticket *ticket = [NSKeyedUnarchiver unarchiveObjectWithData:ticketData];
    TicketViewController *ticketVC = [[TicketViewController alloc] initTicketController:ticket];
    UITabBarController *mainVC = (UITabBarController*) self.window.rootViewController;
    [mainVC setSelectedIndex:2];
    UINavigationController *favoritesVC = (UINavigationController*) mainVC.selectedViewController;
    [favoritesVC pushViewController:ticketVC animated:YES];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DataModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
