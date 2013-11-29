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

@interface EpisodeViewController ()
@end

@implementation EpisodeViewController
@synthesize MyTableView = _MyTableView;

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
            [self setTitle:[channelInfo objectForKey:@"Name"]];
        } @catch (NSException *e) {
            NSLog(@"Caught an exception %@", e);
        }
    }
}

- (void)setStreamer:(AudioStreamer *)streamer
{
    _streamer = streamer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [episode_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *channelInfo;
    UITableViewCell *cell;
    UIFont *myFont;
    
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Ep_Cell" forIndexPath:indexPath];
        myFont = [ UIFont fontWithName: @"Arial" size: 10.0 ];
        cell.textLabel.font  = myFont;
        channelInfo = episode_list[indexPath.row];
        cell.textLabel.text = channelInfo[PROG_TITLE];
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
                                   RSSParser *parser = [[RSSParser alloc] init:data];
                                   XpathInfo *path_dict = [parser parse];
                                   NSString *tempStr;
                                   XmlElement *titleElement;
                                   XmlElement *urlElement;
                                   XmlElement *episodeElement;
                                   XmlElement *partElement;
                                   NSMutableArray *titleArray = [path_dict getXpath:XPATH_FOR_TITLE];
                                   NSMutableArray *urlArray = [path_dict getXpath:XPATH_FOR_URL];
                                   NSMutableArray *episodeArray = [path_dict getXpath:XPATH_FOR_EPISODE];
                                   NSMutableArray *partArray = [path_dict getXpath:XPATH_FOR_PART];
                                   
                                   episode_list = [[NSMutableArray alloc] init];
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
                                       [episode_list addObject:ep_info];
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

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url;
    NSString *urlstr;
    NSMutableArray *channelInfo;
    
    @try {
        channelInfo = episode_list[indexPath.row];

        if (cur_play_episode == nil) {
            cur_play_episode = channelInfo;
            urlstr = channelInfo[PROG_URL];
            url = [[NSURL alloc] initWithString:urlstr];
            if ([_streamer isPlaying]) {
                [_streamer stop];
            }
            [_streamer updateURL:url];
            [_streamer start];
        } else {
            if ([channelInfo[PROG_TITLE] isEqualToString:cur_play_episode[PROG_TITLE]]) {
                if ([_streamer isPlaying]) {
                    [_streamer pause];
                } else if ([_streamer isPaused]) {
                    [_streamer start];
                } else {
                    [_streamer stop];
                }
            } else {
                cur_play_episode = channelInfo;
                urlstr = channelInfo[PROG_URL];
                url = [[NSURL alloc] initWithString:urlstr];
                if (_streamer != nil) {
                    [_streamer stop];
                }
                [_streamer updateURL:url];
                [_streamer start];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

@end
