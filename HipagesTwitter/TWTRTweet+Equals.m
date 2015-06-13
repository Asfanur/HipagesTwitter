//
//  TWTRTweet+Equals.m
//  TestFabric
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "TWTRTweet+Equals.h"

@implementation TWTRTweet (Equals)

- (BOOL)isEqual:(id)object {
    return [self.tweetID isEqualToString:((TWTRTweet *)object).tweetID];
    
}

- (NSUInteger)hash {
    return [self.tweetID hash];
}

@end
