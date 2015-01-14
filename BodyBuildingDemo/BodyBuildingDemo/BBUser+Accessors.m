//
//  BBUser+Accessors.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUser+Accessors.h"

@implementation BBUser (Accessors)
+ (instancetype)createOrUpdatedWithDictionary:(NSDictionary*)dataDictionary inContext:(NSManagedObjectContext*)context
{
    BBUser *user;
    NSNumber *userID = dataDictionary[@"userId"];
    if (!(user = [self loadUserById:userID inContext:context])) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
    user.userId = userID;
    user.userName = dataDictionary[@"userName"];
    user.realName = dataDictionary[@"realName"];
    user.city = dataDictionary[@"city"];
    user.state = dataDictionary[@"state"];
    user.country = dataDictionary[@"country"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    user.birthday = [df dateFromString: dataDictionary[@"birthday"]];

    
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    user.createdAt = [df dateFromString: dataDictionary[@"createdAt"]];
    user.updatedAt = [df dateFromString: dataDictionary[@"updatedAt"]];

    
    return user;
}

+ (instancetype)loadUserById:(NSNumber*)userId inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error fetching user with id: %li Error %@, %@", (long)userId, error, error.userInfo);
    }
    if (results) {
        return [results lastObject];
    }
    return nil;
}

- (NSInteger)age
{
    NSInteger years = [[[NSCalendar currentCalendar] components: NSCalendarUnitYear
                                                       fromDate: self.birthday
                                                         toDate: [NSDate date]
                                                        options: 0]
                       year];
    return years;
}


@end
