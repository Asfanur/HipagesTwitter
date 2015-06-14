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
@interface TwittTableViewController ()
@property (nonatomic, strong) NSArray *tweets; // Hold all the loaded tweets


@end

@implementation TwittTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Automatic row heigh calculation
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    
    // Call convenience method to get the feed
    __weak typeof(self) weakSelf = self;
    [TwitterFeedDownloader fetchTwitterFeedWithCompletionBlock:^(NSArray *model, NSError *error) {
        if (model.count > 0) {
            weakSelf.tweets = model;
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showAlert:error.localizedDescription];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark showAlert Method
// Show error if any
-(void)showAlert:(NSString *)message {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}




# pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}
- (TWTRTweetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    // Configure Tweet Cell
    [cell configureWithTweet:tweet];
    // Customize Theme 
    cell.tweetView.theme = TWTRTweetViewThemeDark;
    cell.tweetView.primaryTextColor = [UIColor whiteColor];
    cell.tweetView.backgroundColor = [UIColor orangeColor];
    return cell;
}

@end
