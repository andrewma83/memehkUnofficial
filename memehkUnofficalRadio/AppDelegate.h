//
//  AppDelegate.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ProgramViewController *myRootViewController;
    BOOL launching;
}
- (void) setMyRootViewController:(ProgramViewController *) controller;
@property (strong, nonatomic) UIWindow *window;

@end
