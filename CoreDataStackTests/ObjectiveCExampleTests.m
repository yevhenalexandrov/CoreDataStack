//
//  ObjectiveCExampleTests.m
//  CoreDataStack
//
//  Created by Robert Edwards on 5/4/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CoreDataStackTests-Swift.h"
#import <CoreDataStack/CoreDataStack.h>

@interface ObjectiveCExampleTests : XCTestCase

@property (nonatomic, strong) NestedContextStack *nestedStack;
@property (nonatomic, strong) SharedCoordinatorStack *sharedCoordinatorStack;

@end

@implementation ObjectiveCExampleTests

- (void)setUp {
    [super setUp];

    XCTestExpectation *ex1 = [self expectationWithDescription:@"Callback 1"];
    XCTestExpectation *ex2 = [self expectationWithDescription:@"Callback 2"];

    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.nestedStack = [[NestedContextStack alloc] initWithModelName:@"TestModel" inBundle:bundle callback:^(BOOL success, NSError *error) {
        XCTAssertTrue(success);
        [ex1 fulfill];
    }];
    self.sharedCoordinatorStack = [[SharedCoordinatorStack alloc] initWithModelName:@"TestModel" inBundle:bundle callback:^(BOOL success, NSError *error) {
        XCTAssertTrue(success);
        [ex2 fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testNestedInitializaton {
    XCTAssert(YES, @"Pass");

    XCTAssertNotNil(self.nestedStack);
    XCTAssertNotNil(self.nestedStack.mainQueueContext);

    NSManagedObjectContext *worker = [self.nestedStack newBackgroundWorkerMOC];
    XCTAssertNotNil(worker);
}

- (void)testSharedStoreInitialization {
    XCTAssertNotNil(self.sharedCoordinatorStack);
    XCTAssertNotNil(self.sharedCoordinatorStack.mainContext);

    NSManagedObjectContext *worker = [self.sharedCoordinatorStack newBackgroundContextWithShouldReceiveUpdates:YES];
    XCTAssertNotNil(worker);
}

@end