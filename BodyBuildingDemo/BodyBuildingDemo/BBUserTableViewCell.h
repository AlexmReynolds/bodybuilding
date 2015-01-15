//
//  BBUserTableViewCell.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBUser;
@interface BBUserTableViewCell : UITableViewCell
@property (nonatomic, strong) BBUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

+ (CGFloat)cellHeightInTableView:(UITableView *)tableView forUser:(BBUser*)user;
@end
