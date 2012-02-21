//
//  NSNotificationCenter+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-24.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSelectFriendNotification @"kSelectFriendNotification"
#define kSelectChildLabelNotification @"kSelectChildLabelNotification"

@interface NSNotificationCenter (Addition)

+ (void)postSelectFriendNotificationWithUserDict:(NSDictionary *)userDict;
+ (void)postSelectChildLabelNotificationWithIdentifier:(NSString *)identifier;
+ (void)registerSelectFriendNotificationWithSelector:(SEL)selector target:(id)aTarget;
+ (void)registerSelectChildLabelNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

@end
