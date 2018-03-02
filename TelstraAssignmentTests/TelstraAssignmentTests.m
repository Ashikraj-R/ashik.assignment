//
//  TelstraAssignmentTests.m
//  TelstraAssignmentTests
//
//  Created by Ashikraj R on 02/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainViewController.h"
#import "ItemArrayViewModel.h"
#import "CustomTableCell.h"

@interface TelstraAssignmentTests : XCTestCase

@property (nonatomic) MainViewController *testViewController;
@property (nonatomic) ItemArrayViewModel *mainTestViewModel;

@end

@implementation TelstraAssignmentTests

- (void)setUp {
    [super setUp];
    
    //Initializing the required global objects
    self.mainTestViewModel = [[ItemArrayViewModel alloc] init];
    self.testViewController = [[MainViewController alloc] initWithViewModel:self.mainTestViewModel];
    
}

- (void)tearDown {
    
    //Setting the objects to nil before tear down to avoid memory leaks
    self.mainTestViewModel = nil;
    self.testViewController = nil;
    [super tearDown];
}

#pragma mark - MainViewController tests

//Simple test to test the initial state of the view model
- (void) testIntialState {
    
    XCTAssertEqualObjects(self.mainTestViewModel.listTitle, @"", @"Initial title is not empty");
    XCTAssertEqual(self.mainTestViewModel.itemsCount, 0, @"Initial item array is not empty");
    
}

//Test to check to response is recevied properly from server
- (void) testDataFromService {
    
    //Expectation to produce delay for async call
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for service call response"];
    
    [self.mainTestViewModel fetchItemswithCompletionHandler:^(NSError *error) {
        
        if(!error) {
            XCTAssertNotEqualObjects(self.mainTestViewModel.listTitle, @"", @"Title returned by service is empty");
            XCTAssertNotEqual(self.mainTestViewModel.itemsCount, 0, @"Item array returned by service is empty");
        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
}

#pragma mark - Table and Custom cell tests

//Test to check the time taken for loading table cells
- (void)testTableLoadPerformance {
    
    //Expectation to produce delay for async call
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for service call response"];
    
    [self.mainTestViewModel fetchItemswithCompletionHandler:^(NSError *error) {
        
        if(!error) {
            [self measureBlock:^{
                [self.testViewController.tableView reloadData];
                [expectation fulfill];
            }];
        }
        else {
            XCTFail(@"Service call failed due to %@", error.description);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

#pragma mark - JSON parser test

//Test for checking if the parser has parsed the json properly
- (void) testJSONModelParser {
    
    
    //Creating static data to mock json value
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *row1 = [[NSMutableDictionary alloc] init];
    [row1 setObject:@"Housing" forKey:@"title"];
    [row1 setObject:@"Space Program" forKey:@"description"];
    [row1 setObject:@"http://test.com" forKey:@"imageHref"];
    
    NSMutableDictionary *row2 = [[NSMutableDictionary alloc] init];
    [row2 setObject:@"Baking" forKey:@"title"];
    [row2 setObject:@"House Program" forKey:@"description"];
    [row2 setObject:@"http://test.in" forKey:@"imageHref"];
    
    [rows addObjectsFromArray:@[row1,row2]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"MainTitle" forKey:@"title"];
    [dictionary setObject:rows forKey:@"rows"];
    
    NSError *error;
    
    ItemArrayModel *itemModel = [[ItemArrayModel alloc] initWithDictionary:dictionary error:&error];
    if(!error) {
        
        XCTAssertEqualObjects(itemModel.title, @"MainTitle");
        
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:0] itemTitle], @"Housing");
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:0] itemDescription], @"Space Program");
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:0] imageURL], @"http://test.com");
        
        XCTAssertEqualObjects(itemModel.title, @"MainTitle");
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:1] itemTitle], @"Baking");
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:1] itemDescription], @"House Program");
        XCTAssertEqualObjects([[itemModel.itemsList objectAtIndex:1] imageURL], @"http://test.in");
    }
    else {
        XCTFail(@"Parsing json failed");
    }
    
}

@end
