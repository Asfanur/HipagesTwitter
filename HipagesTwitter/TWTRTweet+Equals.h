//
//  TWTRTweet+Equals.h
//  TestFabric
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

// -------------------------------------------------------------------------------
//	TWTRTweet Category
//  As We do not have access to TWTRTweet class we created a Cetegory to make each tweet unique according to tweetID
//  We need this category because tweet feed are coming from three different searches and there is a chance of duplicacy
// -------------------------------------------------------------------------------


#import <TwitterKit/TwitterKit.h>

@interface TWTRTweet (Equals)

@end
