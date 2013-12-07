//
//  DetailViewController.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <iAd/ADBannerView.h>

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
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioStreamer.h"

@interface EpisodeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    AudioStreamer *_streamer;
    NSMutableArray *cur_play_episode;
    NSInteger curPlayIndex;
    NSString *epTitle;
    NSString *epAuthor;
    NSMutableDictionary *progDict;
    NSIndexPath *curIndex;
    
    UIImage *playImage;
    UIImage *pauseImage;
    NSTimer *progressTimer;
}

- (void) setStreamer:(AudioStreamer *) streamer;
- (void) setProgressTimer:(BOOL) enable;


@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

- (IBAction) playControl:(id)sender;
- (IBAction) seek:(id)sender;
@end
