//
//  TwitterFeedDownloader.m
//  HipagesTwitter
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "TwitterFeedDownloader.h"
#import "ConstantCollection.h"
#import <TwitterKit/TwitterKit.h>

@interface TwitterFeedDownloader()
typedef void (^DownloadCompletionBlock) (NSArray *array, NSURLResponse *response, NSError *error);

@end

@implementation TwitterFeedDownloader

// -------------------------------------------------------------------------------
//	fetchCountryInfoWithCompletionBlock:completionBlock
//  Convenience method to get the json data about showtime
// -------------------------------------------------------------------------------

+(void)fetchTwitterFeedWithCompletionBlock:(ModelCompletionBlock)completionBlock {
    
    __block NSArray *hipagesPlain = [[NSArray alloc] init];
    __block NSArray *hipagesHash = [[NSArray alloc] init];
    __block NSArray *hipageAt = [[NSArray alloc] init];
    __block NSError *hipagesError;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
         NSDictionary *params = @{@"q" : @"hipages"};
        
        [self fetchQuery:params withCompletionBlock:^(NSArray *array, NSURLResponse *response, NSError *error) {
            if (!error) {
                hipagesPlain = array;
            } else {
                hipagesError = error;
            }
            
            
            
            
        }];
        
    });
    
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        NSDictionary *params = @{@"q" : @"@hipages"};
        
        [self fetchQuery:params withCompletionBlock:^(NSArray *array, NSURLResponse *response, NSError *error) {
            if (!error) {
                hipagesPlain = array;
            } else {
                hipagesError = error;
            }
            
        }];
    });
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        NSDictionary *params = @{@"q" : @"#hipages"};
        
        [self fetchQuery:params withCompletionBlock:^(NSArray *array, NSURLResponse *response, NSError *error) {
            if (!error) {
                hipagesPlain = array;
            } else {
                hipagesError = error;
            }
            
        }];
    });
    
    
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        NSArray *array = [hipagesPlain arrayByAddingObjectsFromArray:hipagesHash];
        array = [array arrayByAddingObjectsFromArray:hipageAt];
        NSSet *set = [NSSet setWithArray:array];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:kCreatedAt ascending:NO];
        completionBlock([set sortedArrayUsingDescriptors:@[descriptor]],hipagesError);
        
    });
    
    
    
    
}

// -------------------------------------------------------------------------------
//	fetchQuery:withCompletionBlock:completionBlock
//  Common gateway to get the json data
// -------------------------------------------------------------------------------
+(void)fetchQuery:(NSDictionary *)params withCompletionBlock:(DownloadCompletionBlock)completionBlock {
    
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        
        NSError *clientError;
        NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                 URLRequestWithMethod:@"GET"
                                 URL:kBaseURL
                                 parameters:params
                                 error:&clientError];
        
        if (request) {
            [[[Twitter sharedInstance] APIClient]
             sendTwitterRequest:request
             completion:^(NSURLResponse *response,
                          NSData *data,
                          NSError *connectionError) {
                 if (data) {
                     // handle the response data e.g.
                     NSError *jsonError;
                     NSDictionary *json = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:0
                                           error:&jsonError];
                     
                     completionBlock([TWTRTweet tweetsWithJSONArray:json[kStatus]],response,connectionError);
                     
                     
                 }
                 else {
                     completionBlock(nil,response,connectionError);
                     NSLog(@"Error: %@", connectionError);
                 }
                 
             }];
        }
        else {
            completionBlock(nil,nil,clientError);
            NSLog(@"Error: %@", clientError);
        }
        
    }];
    
}


@end
