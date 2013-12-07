//
//  AppDelegate.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramViewController.h"
#import "EpisodeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ProgramViewController *myRootViewController;
    EpisodeViewController *myEpViewController;
    BOOL launching;
}
- (void) setMyRootViewController:(ProgramViewController *) controller;
- (void) setMyEpViewController:(EpisodeViewController *) controller;
@property (strong, nonatomic) UIWindow *window;

@end
