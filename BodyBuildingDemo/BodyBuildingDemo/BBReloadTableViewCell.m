//
//  BBReloadTableViewCell.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBReloadTableViewCell.h"
@interface BBReloadTableViewCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageCenter;

@end
@implementation BBReloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)startLoading
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    self.messageLabel.text = NSLocalizedString(@"Loading", @"loading");
    self.messageCenter.constant = - self.spinner.bounds.size.width;
    [self.messageLabel.superview layoutIfNeeded];
}

- (void)stopLoading
{
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    self.messageLabel.text = NSLocalizedString(@"Done", @"done");
    self.messageCenter.constant = 0.0;
    [self.messageLabel.superview layoutIfNeeded];
}
+ (CGFloat)cellHeightInTableView:(UITableView *)tableView
{
    return 100;
}
@end
