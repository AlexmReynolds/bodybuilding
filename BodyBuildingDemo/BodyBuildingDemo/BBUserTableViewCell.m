//
//  BBUserTableViewCell.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUserTableViewCell.h"
#import "BBUser+Accessors.h"

@interface BBUserTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation BBUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    [self removeNotesObserver];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(BBUser *)user
{
    if(_user){
        [self removeNotesObserver];
    }
    _user = user;

    [_user addObserver:self forKeyPath:@"notes" options:NSKeyValueObservingOptionNew context:nil];

    
    self.userNameLabel.text = user.userName;
    
    NSString *ageString = @"";
    if(user.age != nil){
        ageString = [NSString stringWithFormat:@"%li", (long)[user.age integerValue]];
    }
    self.ageLabel.text = ageString;
    
    self.cityLabel.text = user.city;
    self.stateCountryLabel.text = [NSString stringWithFormat:@"%@,%@", user.state, user.country];
    self.noteButton.hidden = self.user.notes.length == 0;
}

#pragma mark - Key Value Observing

- (void)removeNotesObserver
{
    @try{
        [_user removeObserver:self forKeyPath:@"notes"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"notes"])
    {
        id notes = [change objectForKey:NSKeyValueChangeNewKey];
        self.noteButton.hidden = (notes != [NSNull null] && ![notes length]);
    }
}


- (IBAction)notePressed:(id)sender {
    if([self.delegate respondsToSelector:@selector(notesButtonPressedAtIndexPath:)]){
        [self.delegate notesButtonPressedAtIndexPath:self.indexPath];
    }
}

+ (CGFloat)cellHeightInTableView:(UITableView *)tableView forUser:(BBUser*)user
{
    CGFloat imageHeight = 70;
    CGFloat imageWidth = 70;
    CGFloat imageLeftPadding = 10;
    CGFloat imageRightPadding = 4;
    CGFloat widthForText = tableView.bounds.size.width - imageWidth - imageLeftPadding - imageRightPadding;
    CGFloat cityHeight = [self heightForString:user.city constrainedToWidth:widthForText];
    CGFloat stateHeight = [self heightForString:user.state constrainedToWidth:widthForText];
    CGFloat buttonHeight = [self heightForString:@"notes" constrainedToWidth:widthForText];
    return MAX(imageHeight + 20, 20 + cityHeight + stateHeight + buttonHeight);
}


+ (CGFloat)heightForString:(NSString*)title constrainedToWidth:(CGFloat)width {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSString *text = title ?: @"test";
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    font = nil;
    attributedText = nil;
    
    return size.height;
}
@end
