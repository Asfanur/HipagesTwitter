//
//  TwitterFeedDownloader.h
//  HipagesTwitter
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterFeedDownloader : NSObject
typedef void (^ModelCompletionBlock) (NSArray *model, NSError * error);
+(void)fetchTwitterFeedWithCompletionBlock:(ModelCompletionBlock)completionBlock;


@end
