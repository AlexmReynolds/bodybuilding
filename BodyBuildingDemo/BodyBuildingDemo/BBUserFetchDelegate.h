//
//  BBUserFetchController.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUserFetchDelegate : NSObject<NSFetchedResultsControllerDelegate>

- (instancetype)initWithTableView:(UITableView*)tableView;

@end
