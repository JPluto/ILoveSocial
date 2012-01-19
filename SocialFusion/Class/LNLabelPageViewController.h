//
//  LNLabelPageViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLabelViewController.h"

@protocol LNLabelPageViewControllerDelegate;
@interface LNLabelPageViewController : UIViewController<LNLabelViewControllerDelegate> {
    NSMutableArray *_labelViews;
    NSUInteger _page;
    id<LNLabelPageViewControllerDelegate> _delegate;
    NSMutableArray *_labelInfoSubArray;
}

@property NSUInteger page;
@property (nonatomic, assign) id<LNLabelPageViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *labelInfoSubArray;

- (id)initWithInfoSubArray:(NSMutableArray *)array pageIndex:(NSUInteger)page;
- (void)selectOtherPage:(NSUInteger)page;
- (void)activateLastLabel:(LabelInfo *)info;
- (void)selectLastLabel;

@end

@protocol LNLabelPageViewControllerDelegate <NSObject>

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectLabelAtIndex:(NSUInteger)index;
- (void)labelPageView:(LNLabelPageViewController *)pageView didRemoveLabelAtIndex:(NSUInteger)index;

@end