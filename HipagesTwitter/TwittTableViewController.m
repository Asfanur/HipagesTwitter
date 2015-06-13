//
//  TwittTableViewController.m
//  HipagesTwitter
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//
#import <TwitterKit/TwitterKit.h>
#import "TwittTableViewController.h"
#import "TwitterFeedDownloader.h"


static NSString * const TweetTableReuseIdentifier = @"TweetCell";
@interface TwittTableViewController ()<TWTRTweetViewDelegate>
@property (nonatomic, strong) NSArray *tweets; // Hold all the loaded tweets


@end

@implementation TwittTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // Explicitly set on iOS 8 if using automatic row heigh calculation
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    __weak typeof(self) weakSelf = self;
    
    [TwitterFeedDownloader fetchTwitterFeedWithCompletionBlock:^(NSArray *model, NSError *error) {
        if (model.count > 0) {
            typeof(self) strongSelf = weakSelf;
            strongSelf.tweets = model;
            [strongSelf.tableView reloadData];
        } else {
            NSLog(@" err%@",error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}
- (TWTRTweetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    [cell configureWithTweet:tweet];
    cell.tweetView.delegate = self;
    return cell;
}
//// Calculate the height of each row
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TWTRTweet *tweet = self.tweets[indexPath.row];
//
//    return [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
