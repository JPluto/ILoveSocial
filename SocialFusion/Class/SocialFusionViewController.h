//
//  SocialFusionViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-8-8.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "WeiboClient.h"

@interface SocialFusionViewController : CoreDataViewController<UIAlertViewDelegate, WBSessionDelegate>

@property(nonatomic, retain) UIAlertView *hasLoggedInAlertView;
@property(nonatomic, retain) IBOutlet UILabel *weiboStatusLabel;
@property(nonatomic, retain) IBOutlet UILabel *renrenStatusLabel;

- (IBAction)renrenLogIn:(id)sender;
- (IBAction)weiboLogIn:(id)sender;
- (IBAction)gotoMain:(id)sender;

@end
