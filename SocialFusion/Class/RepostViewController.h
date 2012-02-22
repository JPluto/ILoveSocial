//
//  RepostViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "WebStringToImageConverter.h"
#import "NewFeedRootData.h"

typedef  enum kShareStyle {
    kNewBlog           =1,
    kPhoto          =2,
    kAlbum          =6,
    kShare          =20,
    kRenrenStatus   =30,
    kWeiboStatus    =40
    
} kShareStyle;
@interface RepostViewController : PostViewController
{
    kShareStyle _style;
    NewFeedRootData* _feedData;
}

@property (nonatomic, retain) NewFeedRootData* feedData;

-(void)setStyle:(kShareStyle)style;

@end
