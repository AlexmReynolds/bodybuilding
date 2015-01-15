//
//  BBNotesPreviewViewController.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBNotesPreviewViewController : UIViewController
@property (nonatomic, copy) NSString *notes;

- (void)animateIn:(void(^)(BOOL finished))completion;

@end
