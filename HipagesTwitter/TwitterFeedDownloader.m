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
    
    __block NSError *hipagesError;
    __block int  i = 0;;
    __block NSArray *allHipagesTwitts = [[NSArray alloc] init];
    
    
    
    NSArray *paramArray = @[@"hipages",@"@hipages",@"#hipages"];
    for (NSString *param in paramArray) {
        NSDictionary *keyValueDictionary = @{@"q" : param};
        
        [self fetchQuery:keyValueDictionary withCompletionBlock:^(NSArray *array, NSURLResponse *response, NSError *error) {
            
            if (!error) {
                allHipagesTwitts = [allHipagesTwitts arrayByAddingObjectsFromArray:array];
            } else {
                hipagesError = error;
            }
            i++;
            if (i == paramArray.count) {
                NSLog(@"Hi, I'm the final block!\n");
                
                NSSet *set = [NSSet setWithArray:allHipagesTwitts];
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:kCreatedAt ascending:NO];
                completionBlock([set sortedArrayUsingDescriptors:@[descriptor]],hipagesError);
                
                
            }
            
        }];
        
    }
     
    
    
}

// -------------------------------------------------------------------------------
//	fetchQuery:withCompletionBlock:completionBlock
//  Common gateway to get the json data
// -------------------------------------------------------------------------------
+(void)fetchQuery:(NSDictionary *)params withCompletionBlock:(DownloadCompletionBlock)completionBlock {
    
    // dispatch_async(dispatch_get_main_queue(), ^{
    
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
    
    // });
    
}


@end
