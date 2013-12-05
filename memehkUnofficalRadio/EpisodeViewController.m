//
//  DetailViewController.m
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import "EpisodeViewController.h"
#import "RSSParser.h"
#import "XpathInfo.h"
#import "EpisodeViewCell.h"


@interface EpisodeViewController ()
@end

@implementation EpisodeViewController
@synthesize MyTableView = _MyTableView;
@synthesize controlButton = _controlButton;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    NSDictionary *channelInfo;
    NSString *title;
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        cur_play_episode = nil;
        
        @try {
            // Update the view.
            channelInfo = (NSDictionary *) newDetailItem;
            [self pollURL];
            title = [channelInfo objectForKey:@"Name"];
            epTitle = title;
            [self setTitle:[channelInfo objectForKey:@"Name"]];

            [self setButtonState];
        } @catch (NSException *e) {
            NSLog(@"Caught an exception %@", e);
        }
    }
}

- (void) setButtonState
{
    if ([_streamer isPaused]) {
        [_controlButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [_controlButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (void) setMediaInfo
{
    NSArray *keys;
    NSArray *values;
    NSDictionary *mediaInfo;
    NSMutableArray *channelInfo;
    NSString *episodeName;
    
    //channelInfo = episode_list[curPlayIndex];
    episodeName = channelInfo[PROG_TITLE];
    keys = [NSArray arrayWithObjects: MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyArtist, nil];
    values = [NSArray arrayWithObjects:epTitle, episodeName, nil];
    mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self myRemoveObserver];
    [_streamer stop];
    [super viewDidDisappear:animated];
}

- (IBAction)playControl:(id)sender
{
    if ([_streamer isPaused]) {
        [_streamer start];
    } else {
        [_streamer pause];
    }
    
    [self setButtonState];
}

- (void)setStreamer:(AudioStreamer *)streamer
{
    _streamer = streamer;
}

- (void) myAddObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStreamerNotification:)
                                                 name:ASStatusChangedNotification
                                               object:nil];
    
}

- (void) myRemoveObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try {
        // Do any additional setup after loading the view, typically from a nib.
        if ([_streamer isPlaying]) {
            [self setButtonState];
        }
        
        [self myAddObserver];
        curPlayIndex = -1;
    }
    @catch (NSException *exception) {
        NSLog(@"catch exception %@", exception);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    int episode_no;
    
    episode_no = [progDict count] - section;
    title = [[NSString alloc] initWithFormat:@"第%ld集", (long) episode_no];
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [progDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *tempArray;
    int realSection;
    
    realSection = [progDict count] - section;
    NSString *key = [[NSString alloc] initWithFormat:@"%ld", (long)realSection];
    
    tempArray = [progDict objectForKey:key];
    return [tempArray count];
}

- (NSMutableArray *) getRowInSection:(NSIndexPath *) indexPath
{
    NSMutableArray *retval;
    NSString *key;
    int realSection;
    
    realSection = [progDict count] - indexPath.section;
    key = [[NSString alloc] initWithFormat:@"%ld", (long) realSection];
    retval = [progDict objectForKey:key];
    
    return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *channelInfo;
    EpisodeViewCell *cell;
    UIFont *myFont;
    NSString *titleStr;
    NSMutableArray *tempArray;
    
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Ep_Cell" forIndexPath:indexPath];
        myFont = [ UIFont fontWithName: @"Arial" size: 12.0 ];
        cell.textLabel.font  = myFont;
        
        tempArray = [self getRowInSection:indexPath];
        channelInfo = tempArray[indexPath.row];
        
        titleStr = [[NSString alloc] initWithFormat:@"Part (%@): %@", channelInfo[PROG_PART], channelInfo[PROG_TITLE]];
        cell.textLabel.text = titleStr;
        
        if (curIndex != nil && curIndex.section == indexPath.section && curIndex.row == indexPath.row) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void) pollURL
{
    NSString *url_str;
    NSURLRequest *request;
    NSURL *url;
    NSDictionary *channel_info;
    int channel_id;
    
    @try {
        channel_info = (NSDictionary *) _detailItem;
        channel_id = [[channel_info objectForKey:@"ID"] intValue];
        url_str = [[NSString alloc] initWithFormat:MEMEHK_URL_STR, channel_id];
        url = [[NSURL alloc] initWithString:url_str];
        request = [[NSURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   int i;
                                   NSArray *ep_info;
                                   progDict = [[NSMutableDictionary alloc] init];
                                   RSSParser *parser = [[RSSParser alloc] init:data];
                                   XpathInfo *path_dict = [parser parse];
                                   NSString *tempStr;
                                   XmlElement *titleElement;
                                   XmlElement *urlElement;
                                   XmlElement *episodeElement;
                                   XmlElement *partElement;
                                   NSMutableArray *tempArray;
                                   NSMutableArray *titleArray = [path_dict getXpath:XPATH_FOR_TITLE];
                                   NSMutableArray *urlArray = [path_dict getXpath:XPATH_FOR_URL];
                                   NSMutableArray *episodeArray = [path_dict getXpath:XPATH_FOR_EPISODE];
                                   NSMutableArray *partArray = [path_dict getXpath:XPATH_FOR_PART];
                                   
                                   //episode_list = [[NSMutableArray alloc] init];
                                   for (i = 0; i < [titleArray count]; i++) {
                                       titleElement = titleArray[i];
                                       urlElement =urlArray[i];
                                       episodeElement = episodeArray[i];
                                       partElement = partArray[i];
                                       
                                       tempStr = titleElement.value;
                                       ep_info = [[NSArray alloc] initWithObjects:titleElement.value,
                                                  urlElement.value,
                                                  episodeElement.value,
                                                  partElement.value,
                                                  nil];
                                       //[episode_list addObject:ep_info];
                                       
                                       tempArray = [progDict objectForKey:ep_info[PROG_EPISODE]];
                                       if (tempArray == nil) {
                                           tempArray = [[NSMutableArray alloc] init];
                                           [progDict setValue:tempArray forKey:ep_info[PROG_EPISODE]];
                                       }
                                       
                                       [tempArray addObject:ep_info];
                                   }
                                   
                                   @try {
                                       [_MyTableView performSelectorOnMainThread:@selector(reloadData)
                                                                    withObject:nil
                                                                 waitUntilDone:YES];
                                   }
                                   @catch (NSException *exception) {
                                       NSLog(@"%@", exception);
                                   }
                               }];
    } @catch (NSException *e) {
        NSLog(@"catch exception %@", e);
    }
}

- (NSMutableArray *) getChannelInfo:(NSIndexPath *) indexPath
{
    NSMutableArray *tempArray;
    NSMutableArray *retval;
    NSString *key;
    int realSection;
    
    realSection = [progDict count] - indexPath.section;
    key = [[NSString alloc] initWithFormat:@"%ld", (long) realSection];
    tempArray = [progDict objectForKey:key];
    retval = tempArray[indexPath.row];
                   
    return retval;
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url;
    NSString *urlstr;
    NSMutableArray *channelInfo;
    NSString *episodeTitle;
    
    @try {
        channelInfo = [self getChannelInfo:indexPath];

        if (cur_play_episode == nil) {
            cur_play_episode = channelInfo;
            curIndex = indexPath;
            urlstr = channelInfo[PROG_URL];
            url = [[NSURL alloc] initWithString:urlstr];
            if ([_streamer isPlaying]) {
                [self myRemoveObserver];
                [_streamer stop];
                [self myAddObserver];
            }
            [_streamer updateURL:url];
            [_streamer start];
            curPlayIndex = indexPath.row;
        } else {
            if ([channelInfo[PROG_TITLE] isEqualToString:cur_play_episode[PROG_TITLE]]) {
                if ([_streamer isPlaying]) {
                    [_streamer pause];
                } else if ([_streamer isPaused]) {
                    [_streamer start];
                    //curPlayIndex = indexPath.row;
                    curIndex = indexPath;
                } else {
                    [self myRemoveObserver];
                    [_streamer stop];
                    [self myAddObserver];
                }
            } else {
                cur_play_episode = channelInfo;
                urlstr = channelInfo[PROG_URL];
                url = [[NSURL alloc] initWithString:urlstr];
                if (_streamer != nil) {
                    [self myRemoveObserver];
                    [_streamer stop];
                    [self myAddObserver];
                }
                [_streamer updateURL:url];
                [_streamer start];
                episodeTitle = channelInfo[PROG_TITLE];
                
                //[self setMediaInfo:eps];
                //curPlayIndex = indexPath.row;
                curIndex = indexPath;
            }
        }
        
        [tableView reloadData];
        [self setButtonState];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}


- (void) play_audio
{
    [_streamer start];
}

- (void) receiveStreamerNotification : (NSNotification *) notification
{
    NSURL *url;
    NSString *urlstr;
    NSMutableArray *channelInfo;
    NSMutableArray *ep_list;
    
    if ([_streamer isFinishing]) {
        ep_list = [self getRowInSection:curIndex];
        curIndex = [NSIndexPath indexPathForRow:curIndex.row + 1 inSection:curIndex.section];
        if (curIndex.row < [ep_list count]) {
            [self myRemoveObserver];
            [_streamer stop];
            [self myAddObserver];
            channelInfo = [self getChannelInfo:curIndex];
            urlstr = channelInfo[PROG_URL];
            url = [[NSURL alloc] initWithString:urlstr];
            [_streamer updateURL:url];
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(play_audio)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    [_MyTableView reloadData];
}

@end
