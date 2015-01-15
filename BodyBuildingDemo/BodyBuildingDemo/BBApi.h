//
//  BBApi.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completionBlock)(NSDictionary*data, NSError*error);

@interface BBApi : NSObject
+ (void)getUsersForPage:(NSInteger)page completion:(completionBlock)completion;

@end
