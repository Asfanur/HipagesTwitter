//
//  TWTRTweet+Equals.m
//  TestFabric
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "TWTRTweet+Equals.h"

@implementation TWTRTweet (Equals)

// -------------------------------------------------------------------------------
//	isEqual:object
//  Get the unique Twitter feed according to tweetID
// -------------------------------------------------------------------------------


- (BOOL)isEqual:(id)object {
    return [self.tweetID isEqualToString:((TWTRTweet *)object).tweetID];
    
}

// -------------------------------------------------------------------------------
//	hash
//  Generate hash value for our Twitter feed
// -------------------------------------------------------------------------------


- (NSUInteger)hash {
    return [self.tweetID hash];
}

@end
