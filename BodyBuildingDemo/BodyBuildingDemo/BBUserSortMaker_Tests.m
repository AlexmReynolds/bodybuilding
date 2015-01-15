//
//  BBUserSortMaker_Tests.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "BBUserSortMaker.h"

@interface BBUserSortMaker_Tests : XCTestCase
@property (nonatomic, strong) BBUserSortMaker *sut;
@end

@implementation BBUserSortMaker_Tests

- (void)setUp {
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        void (^passedBlock)( id response, NSError *error );
        [invocation getArgument: &passedBlock atIndex: 4];
        NSArray *response = @[];
        passedBlock(response, nil);
    };
    OCMockObject *mock = [OCMockObject mockForClass:[BBApi class]];
    [[[[mock stub] andDo:proxyBlock] ignoringNonObjectArgs] getUsersForPage:1 sortOrder:0 completion:OCMOCK_ANY];
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    _sut = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPassingDefaultOption_ShouldReturnNSSortWithKeyId {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionDefault];
    XCTAssertTrue([sort.key isEqualToString:@"id"]);
}

- (void)testPassingAgeAsc_ShouldReturnNSSortWithKeyBirthday {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionAgeASC];
    XCTAssertTrue([sort.key isEqualToString:@"birthday"]);
}

- (void)testPassingAgeDsc_ShouldReturnNSSortWithKeyBirthday {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionAgeDSC];
    XCTAssertTrue([sort.key isEqualToString:@"birthday"]);
}

- (void)testPassingNameAsc_ShouldReturnNSSortWithKeyUserName {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionNameASC];
    XCTAssertTrue([sort.key isEqualToString:@"userName"]);
}

- (void)testPassingNameDsc_ShouldReturnNSSortWithKeyUserName {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionNameDSC];
    XCTAssertTrue([sort.key isEqualToString:@"userName"]);
}

- (void)testPassingDefaultOption_ShouldReturnNSSortWithAscendingTrue {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionDefault];
    XCTAssertTrue(sort.ascending);
}

- (void)testPassingAgeAsc_ShouldReturnNSSortWithAscendingTrue {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionAgeASC];
    XCTAssertTrue(sort.ascending);
}

- (void)testPassingAgeDsc_ShouldReturnNSSortWithAscendingFalse{
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionAgeDSC];
    XCTAssertFalse(sort.ascending);
}

- (void)testPassingNameAsc_ShouldReturnNSSortWithAscendingTrue {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionNameASC];
    XCTAssertTrue(sort.ascending);
}

- (void)testPassingNameDsc_ShouldReturnNSSortWithAscendingFalse {
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:BBUserSortOptionNameDSC];
    XCTAssertFalse(sort.ascending);
}
@end
