//
//  BBUserSortMaker.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/15/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUserSortMaker.h"

@implementation BBUserSortMaker

+ (NSSortDescriptor*)sortDescriptorForOption:(BBUserSortOption)option
{
    NSSortDescriptor *sort = nil;
    switch (option) {
        case BBUserSortOptionAgeASC:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:YES];
            break;
        case BBUserSortOptionAgeDSC:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:NO];
            break;
        case BBUserSortOptionNameASC:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES];
            break;
        case BBUserSortOptionNameDSC:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:NO];
            break;
        case BBUserSortOptionDefault:
        default:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
            break;
    }
    return sort;
}

+ (UIActionSheet *)actionSheetOfOptions
{
    NSString *title = NSLocalizedStringFromTable(@"Sort Order", @"Sort Options",@"title");
    NSString *defaultOption = NSLocalizedStringFromTable(@"Default", @"Sort Options",@"default");
    NSString *ageAsc = NSLocalizedStringFromTable(@"By Age Asc", @"Sort Options",@"age asc");
    NSString *ageDsc = NSLocalizedStringFromTable(@"By Age Dsc", @"Sort Options",@"age dsc");
    NSString *nameAsc = NSLocalizedStringFromTable(@"By Name Asc", @"Sort Options",@"name asc");
    NSString *nameDsc = NSLocalizedStringFromTable(@"By Name Dsc", @"Sort Options",@"name dsc");

    NSString *cancel = NSLocalizedStringFromTable(@"Cancel", @"Sort Options",@"cancel button");
    
    
    return [[UIActionSheet alloc] initWithTitle:title
                                         delegate:nil
                                cancelButtonTitle:cancel
                           destructiveButtonTitle:nil
                                otherButtonTitles: defaultOption, nameAsc, nameDsc, ageAsc, ageDsc, nil];
}

+ (UIAlertView *)alertViewOfOptions
{
    NSString *title = NSLocalizedStringFromTable(@"Sort Order", @"Sort Options",@"title");
    NSString *defaultOption = NSLocalizedStringFromTable(@"Default", @"Sort Options",@"default");
    NSString *ageAsc = NSLocalizedStringFromTable(@"By Age Asc", @"Sort Options",@"age asc");
    NSString *ageDsc = NSLocalizedStringFromTable(@"By Age Dsc", @"Sort Options",@"age dsc");
    NSString *nameAsc = NSLocalizedStringFromTable(@"By Name Asc", @"Sort Options",@"name asc");
    NSString *nameDsc = NSLocalizedStringFromTable(@"By Name Dsc", @"Sort Options",@"name dsc");
    
    NSString *cancel = NSLocalizedStringFromTable(@"Cancel", @"Sort Options",@"cancel button");
    
    return [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles: defaultOption, nameAsc, nameDsc, ageAsc, ageDsc, nil];
}

@end
