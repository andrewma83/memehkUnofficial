//
//  DetailViewController.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#define HKREPORTER_URL_STR  @"http://www.hkreporter.com/myradio/channel_podcast.php?channelid=%d"
#define XPATH_FOR_ENCLOSURE_URL @"//rss/channel/item/enclosure"
#define XPATH_FOR_TITLE @"//rss/channel/item/title"

typedef enum {PROG_TITLE=0, PROG_URL, NO_PROG_TYPE} PROG_T;
#import <UIKit/UIKit.h>
#import "AudioStreamer.h"

@interface EpisodeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *episode_list;
    AudioStreamer *_streamer;
    NSMutableArray *cur_play_episode;
}

- (void) setStreamer:(AudioStreamer *) streamer;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@end
