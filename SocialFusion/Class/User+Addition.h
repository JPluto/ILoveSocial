//
//  User+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-17.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "User.h"

@interface User (Addition)

+ (User *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, readonly) NSString *nameFirstLetter;

@end
