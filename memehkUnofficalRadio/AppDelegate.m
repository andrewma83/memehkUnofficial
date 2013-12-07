//
//  AppDelegate.m
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgramViewController.h"

@implementation AppDelegate

- (void) audio:(BOOL) pause
{
    ProgramViewController *mainController;
    
    @try {
        mainController = (ProgramViewController *) myRootViewController;
        
        if (pause) {
            [mainController pause];
            
        } else {
            if (!launching) {
                [mainController resume];
            } else {
                launching = NO;
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"catch exception: %@", exception);
    }
}

- (void) setMyEpViewController:(EpisodeViewController *)controller
{
    myEpViewController = controller;
}

- (void) setMyRootViewController:(ProgramViewController *)controller
{
    myRootViewController = controller;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    launching = YES;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#if 0
    // Disable the audio resume for the time being
    [self audio:YES];
#endif
    [myEpViewController setProgressTimer:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

#if 0
    // Disable audio resume for the time being
    [self audio:NO];
#endif
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [myEpViewController setProgressTimer:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
