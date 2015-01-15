//
//  BBUserDetailsController.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUserDetailsController.h"
#import "BBUser+Accessors.h"

@interface BBUserDetailsController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateCountryLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesView;

@property (weak, nonatomic) IBOutlet UILabel *realNameField;
@property (weak, nonatomic) IBOutlet UILabel *ageField;
@property (weak, nonatomic) IBOutlet UILabel *heightField;
@property (weak, nonatomic) IBOutlet UILabel *weightField;
@property (weak, nonatomic) IBOutlet UILabel *bodyFatField;
@end

@implementation BBUserDetailsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.user.userName;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.avatarImageView downloadImageWithURL:[NSURL URLWithString:self.user.profilePicUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            self.avatarImageView.image = image;
            
            // cache the image for use later (when scrolling up)
        }
    }];
    NSString *weightUnits = NSLocalizedString(@"lbs", @"pounds abrv");
    self.realNameField.text = self.user.realName;
    self.ageField.text = [NSString stringWithFormat:@"%li",(long)self.user.age];
    self.heightField.text = [self.user heightStringInStardardUnits];
    self.weightField.text = [NSString stringWithFormat:@"%@%@", self.user.weight, weightUnits];
    self.bodyFatField.text = [NSString stringWithFormat:@"%li%%", [self.user.bodyfat integerValue]];
    self.notesView.text = self.user.notes;
    
    self.notesView.inputView = [self makeToolbarForKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUser:(BBUser *)user
{
    _user = user;

}

- (UIToolbar*)makeToolbarForKeyboard
{
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", @"clear button title") style:UIBarButtonItemStylePlain target:self action:@selector(clearPressed:)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"done button title") style:UIBarButtonItemStylePlain target:self.notesView action:@selector(resignFirstResponder)];
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.items = [NSArray arrayWithObjects:
                           clear,
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           done,
                           nil];
    [toolbar sizeToFit];
    return toolbar;
}

- (void)updateNotes
{
    self.user.notes = self.notesView.text;
    NSError *error = nil;
    [self.user.managedObjectContext save:&error];
    if(error != nil){
        NSLog(@"error saving notes");
    }
}

#pragma mark - Keyboard Methods


#pragma mark - Actions

- (IBAction)clearPressed:(id)sender {
    self.notesView.text = nil;
}
- (IBAction)savePressed:(id)sender {
    [self updateNotes];
}
@end
