//
//  BBReloadTableViewCell.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBReloadTableViewCell : UITableViewCell

+ (CGFloat)cellHeightInTableView:(UITableView *)tableView;

- (void)startLoading;
- (void)stopLoading;
- (void)noMoreResults;

@end
