//
//  BBUserSortMaker.h
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, BBUserSortOption) {
    BBUserSortOptionDefault = 0,
    BBUserSortOptionNameASC,
    BBUserSortOptionNameDSC,
    BBUserSortOptionAgeASC,
    BBUserSortOptionAgeDSC
    
};

@interface BBUserSortMaker : NSObject
+ (NSSortDescriptor*)sortDescriptorForOption:(BBUserSortOption)option;
+ (UIActionSheet*)actionSheetOfOptions;
+ (UIAlertView*)alertViewOfOptions;
@end
