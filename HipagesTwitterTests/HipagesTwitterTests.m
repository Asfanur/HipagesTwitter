//
//  HipagesTwitterTests.m
//  HipagesTwitterTests
//
//  Created by Asfanur Arafin on 13/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TwitterFeedDownloader.h"

@interface HipagesTwitterTests : XCTestCase

@end

@implementation HipagesTwitterTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
     [super tearDown];
}


// -------------------------------------------------------------------------------
//	testTwitterFeedDownloader
//  Check if the data is downloaded correctly
// -------------------------------------------------------------------------------


-(void)testTwitterFeedDownloader {
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Twitter Feed Downloader"];
    [TwitterFeedDownloader fetchTwitterFeedWithCompletionBlock:^(NSArray *model, NSError *error) {
        XCTAssertNotNil(model, @"data should not be nil");
        XCTAssertNil(error, @"error should be nil");
        XCTAssertGreaterThan(model.count,0, @"Wrong Count");
        [completionExpectation fulfill];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    
}

@end
