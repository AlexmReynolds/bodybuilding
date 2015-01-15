//
//  BBUser.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BBUser : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * bodyfat;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * profilePicUrl;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * age;

@end
