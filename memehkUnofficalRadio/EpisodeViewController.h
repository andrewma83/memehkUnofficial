//
//  DetailViewController.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#define HKREPORTER_URL_STR  @"http://www.hkreporter.com/myradio/channel_podcast.php?channelid=%d"
#define MEMEHK_URL_STR    @"http://zerotester.dontexist.org/rss/memehk.php?prog_id=%d"

#if 0
#define XPATH_FOR_ENCLOSURE_URL @"//rss/channel/item/enclosure"
#define XPATH_FOR_TITLE @"//rss/channel/item/title"
#endif

#define XPATH_FOR_TITLE     @"//program/title"
#define XPATH_FOR_URL       @"//program/url"
#define XPATH_FOR_EPISODE   @"//program/episode"
#define XPATH_FOR_PART      @"//program/part"

typedef enum {PROG_TITLE=0, PROG_URL, PROG_EPISODE, PROG_PART, NO_PROG_TYPE} PROG_T;
#import <UIKit/UIKit.h>
#import "AudioStreamer.h"

@interface EpisodeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *episode_list;
    AudioStreamer *_streamer;
    NSMutableArray *cur_play_episode;
    NSInteger curPlayIndex;
}

- (void) setStreamer:(AudioStreamer *) streamer;

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
- (IBAction) playControl:(id)sender;
@end
