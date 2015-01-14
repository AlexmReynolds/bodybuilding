//
//  BBUserFetchedResultsController.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
@interface BBUserFetchedResultsController : NSFetchedResultsController

@property (nonatomic, weak) UITableView *tableView;

@end
