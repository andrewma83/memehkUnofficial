//
//  MasterViewController.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"

@interface ProgramViewController : UITableViewController
{
    AudioStreamer *_streamer;
}

- (void) pause;
- (void) resume;
@end
