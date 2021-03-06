//
//  BBApi.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBApi.h"
#import "AFHTTPSessionManager.h"

static NSUInteger kPerPageNumber = 10;
@implementation BBApi
+ (AFHTTPSessionManager*)sharedAFNetworking {
    
    static AFHTTPSessionManager *sharedClient = nil;
    
    static dispatch_once_t onceToken;

    
    dispatch_once(&onceToken, ^{
        
        NSString *urlString = @"http://107.170.231.93/";
        NSURL *url = [NSURL URLWithString:urlString];
        sharedClient = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    });
    return sharedClient;
}

+ (void)getUsersForPage:(NSInteger)page sortOrder:(NSSortDescriptor*)sortOrder completion:(completionBlock)completion
{
    AFHTTPSessionManager *manager = [self sharedAFNetworking];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"limit" : @(kPerPageNumber),@"skip" : @(kPerPageNumber * (page - 1))}];
    
    if(sortOrder){
        [params setObject:[NSString stringWithFormat:@"%@ %@", sortOrder.key, sortOrder.ascending ? @"ASC" : @"DESC"] forKey:@"sort"];
    }
    
    [manager GET:@"member" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completion){
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completion){
            completion(nil,error);
        }
    }];
}
@end
