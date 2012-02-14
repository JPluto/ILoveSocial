//
//  RenrenUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//


#import "RenrenUser.h"
#import "RenrenStatus.h"

@interface RenrenUser (Addition)

+ (RenrenUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)insertFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)insertUserWithName:(NSString *)name userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)isEqualToUser:(RenrenUser *)user;
+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllFriendsOfUser:(RenrenUser *)user inManagedObjectContext:(NSManagedObjectContext *)context;

@end
