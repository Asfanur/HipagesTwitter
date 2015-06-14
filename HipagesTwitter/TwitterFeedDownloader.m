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
//	fetchTwitterFeedWithCompletionBlock:completionBlock
//  Convenience method to get the Combined data about hipages
// -------------------------------------------------------------------------------

+(void)fetchTwitterFeedWithCompletionBlock:(ModelCompletionBlock)completionBlock {
    
    // Receive error if there is any
    __block NSError *hipagesError;
    // keep the count and checks when all the twitter feed arrived
    __block int  downloadCount = 0;
    // An array that accumulated all the twitter feed
    __block NSArray *allHipagesTwitts = [[NSArray alloc] init];
    // array of search keywords
    NSArray *paramArray = @[@"hipages",@"@hipages",@"#hipages"];
    
    // A loop that submits all the twitter search keywords and make a callback when all of the responses has arrived
     for (NSString *param in paramArray) {
        
        NSDictionary *keyValueDictionary = @{@"q" : param};
        [self fetchQuery:keyValueDictionary withCompletionBlock:^(NSArray *array, NSURLResponse *response, NSError *error) {
            
            if (!error) {
                // adds downloaded twitter feed to existing array
                allHipagesTwitts = [allHipagesTwitts arrayByAddingObjectsFromArray:array];
            } else {
                hipagesError = error;
            }
            downloadCount++;
            if (downloadCount == paramArray.count) {
                // Remove duplicate twitter feed
                NSSet *set = [NSSet setWithArray:allHipagesTwitts];
                // Sort the feed according to createdAt field  
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
    
    // Login as guest
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
                     
                 }
                 
             }];
        }
        else {
            completionBlock(nil,nil,clientError);
            
        }
        
    }];
    
     
}


@end
