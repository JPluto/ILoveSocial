//
//  RenrenStatus.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Status.h"


@interface RenrenStatus : Status

@property (nonatomic, retain) NSString * rootStatusID;
@property (nonatomic, retain) NSString * rootText;
@property (nonatomic, retain) NSString * rootUserID;
@property (nonatomic, retain) NSString * forwardMessage;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * rootUserName;
@property (nonatomic, retain) NSString * url;

@end
