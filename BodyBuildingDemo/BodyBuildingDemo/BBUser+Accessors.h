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
- (NSInteger)age;

@end
