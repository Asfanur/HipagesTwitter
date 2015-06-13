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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// -------------------------------------------------------------------------------
//	testNetworkModelDownloader
//  Check if the data is downloaded correctly and the count is correct
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
