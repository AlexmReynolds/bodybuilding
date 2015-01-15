//
//  BBUser+Accessors.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUser+Accessors.h"

@implementation BBUser (Accessors)

- (void)awakeFromInsert
{
    self.age = nil;
}
+ (instancetype)createOrUpdatedWithDictionary:(NSDictionary*)dataDictionary inContext:(NSManagedObjectContext*)context
{
    BBUser *user;
    NSNumber *userID = dataDictionary[@"userId"];
    if (!(user = [self loadUserById:userID inContext:context])) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
    user.userId = userID;
    user.id = dataDictionary[@"id"];

    user.userName = dataDictionary[@"userName"];
    user.realName = dataDictionary[@"realName"];
    user.city = dataDictionary[@"city"] ?: @"";
    user.state = dataDictionary[@"state"] ?: @"";
    user.country = dataDictionary[@"country"] ?: @"";
    user.profilePicUrl = dataDictionary[@"profilePicUrl"];
    
    user.height = dataDictionary[@"height"];
    user.weight = dataDictionary[@"weight"];
    user.bodyfat = dataDictionary[@"bodyfat"];
    
    [user parseDates:dataDictionary];
    
    return user;
}

- (void)parseDates:(NSDictionary*)dataDictionary
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if(dataDictionary[@"birthday"] != [NSNull null]){
        [df setDateFormat:@"yyyy-MM-dd"];
        self.birthday = [df dateFromString: dataDictionary[@"birthday"]];
    }
    
    if(dataDictionary[@"createdAt"] != [NSNull null]){
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        self.createdAt = [df dateFromString: dataDictionary[@"createdAt"]];
        self.updatedAt = [df dateFromString: dataDictionary[@"updatedAt"]];
    }
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

- (NSString*)heightStringInStardardUnits
{
    NSString *string = @"";
    if(self.height){
        NSInteger inchesPerFoot = 12;
        long inches = self.height.integerValue % inchesPerFoot;
        long feet = (self.height.integerValue - inches) / inchesPerFoot;
        string = [NSString stringWithFormat:@"%li\'%li\"",feet,inches];
    }
    return string;
}

- (NSString*)weightStringInStardardUnits
{
    NSString *string = @"";
    if(self.weight){
        NSString *unitsOfMeasure = NSLocalizedString(@"lbs", @"pounds abrv");
        string = [NSString stringWithFormat:@"%@%@",self.weight, unitsOfMeasure];
    }
    return string;
}

- (void) setBirthday:(NSDate *)birthday {
    [self willChangeValueForKey:@"birthday"];
    [self setPrimitiveValue:birthday forKey:@"birthday"];
    if(self.birthday){
        NSInteger year = [[[NSCalendar currentCalendar] components: NSCalendarUnitYear
                                                          fromDate: self.birthday
                                                            toDate: [NSDate date]
                                                           options: 0] year];
        self.age = @(year);
    }
    
    [self didChangeValueForKey:@"birthday"];
}
@end
