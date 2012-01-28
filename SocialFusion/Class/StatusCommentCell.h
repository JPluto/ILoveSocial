//
//  StatusCommentCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCommentData+StatusCommentData_Addition.h"
@interface StatusCommentCell : UITableViewCell
{

    UIButton* _userName;
    UILabel* _status;
    UILabel* _time;
}


@property(nonatomic, retain) IBOutlet UIButton* userName;
@property(nonatomic, retain) IBOutlet UILabel* status;
@property(nonatomic, retain) IBOutlet UILabel* time;


+(float)heightForCell:(StatusCommentData*)feedData;
-(void)configureCell:(StatusCommentData*)feedData colorStyle:(BOOL)bo;
@end
