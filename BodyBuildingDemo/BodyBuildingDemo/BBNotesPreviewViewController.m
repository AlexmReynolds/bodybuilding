//
//  BBNotesPreviewViewController.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBNotesPreviewViewController.h"

@interface BBNotesPreviewViewController ()
@property (strong, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

@implementation BBNotesPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSBundle mainBundle] loadNibNamed:@"BBNotesPreview" owner:self options:nil];
    [self.view addSubview:self.content];
    self.content.layer.cornerRadius = 8.0;
    self.content.clipsToBounds = YES;
    [self addConstraintsToContentView];
    self.notesTextView.text = self.notes;

    [self animateIn:^(BOOL finished) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addConstraintsToContentView
{
    self.content.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self heightForPreview]];
    
    [self.view addConstraints:@[centerY,left,right,height]];
}

- (CGFloat)heightForPreview
{
    CGFloat verticalPadding = 20;
    CGFloat buttonHeight = 30;
    CGFloat oneLineOfText = [self heightForString:@"notes"];
    CGFloat numberOfLinesToPreview = 5;
    return oneLineOfText * numberOfLinesToPreview + buttonHeight + verticalPadding;
}

- (CGFloat)heightForString:(NSString*)title {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSString *text = title ?: @"test";
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    font = nil;
    attributedText = nil;
    
    return size.height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ANimation

- (void)animateIn:(void(^)(BOOL finished))completion
{

    self.content.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:0 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        self.content.transform = CGAffineTransformIdentity;
    } completion:completion];
}

- (void)animateOut:(void(^)(BOOL finished))completion
{
    self.content.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.content.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.content.alpha = 0.0;


    } completion:completion];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"Passing all touches to the next view (if any), in the view stack.");
    return YES;
}

#pragma mark - Actions
- (IBAction)backgroundTapped:(id)sender {
    [self animateOut:^(BOOL finished){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];

    }];

}
- (IBAction)closePressed:(id)sender {
    [self animateOut:^(BOOL finished){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

@end
