//
//  FreindProfileTabelViewCell.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendProfileTabelViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property(nonatomic, retain) IBOutlet UIImageView* headImageView;
@property(nonatomic, retain) IBOutlet UILabel* userName;
@property(nonatomic, retain) IBOutlet UILabel* latestStatus;
@property(nonatomic, retain) IBOutlet UIButton *commentButton;

@end
