//
//  BBUser+Accessors.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUser.h"

@interface BBUser (Accessors)
+ (instancetype)createOrUpdatedWithDictionary:(NSDictionary*)dataDictionary inContext:(NSManagedObjectContext*)context;

//converts a users height which is in inches to a string showing feet and inches
- (NSString*)heightStringInStardardUnits;
// calculates a users age based on birthday and returns current age
- (NSInteger)age;

@end
