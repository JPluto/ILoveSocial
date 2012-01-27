//
//  StatusDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//
#import "StatusDetailController.h"
#import "WeiboClient.h"
#import "RenrenClient.h"
#import "StatusCommentData.h"
#import "NewFeedStatusCell.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "StatusDetailController.h"
#import "StatusCommentData+StatusCommentData_Addition.h"
#import "CommonFunction.h"
#import "NSString+HTMLSet.h"
@implementation StatusDetailController

@synthesize feedData=_feedData;


-(void)addOriStatus
{
    _nameLabel.text=[_feedData getFeedName];

    NSData *imageData = nil;
    if([Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData != nil) {
        _headImage.image = [UIImage imageWithData:imageData];
    }
  
     
    _time.text=[CommonFunction getTimeBefore:_feedData.update_Time];
    
    
    
    
    [(UIScrollView*)self.view setContentSize:CGSizeMake(self.view.frame.size.width*2,390)];
    ((UIScrollView*)self.view).pagingEnabled=YES;
    ((UIScrollView*)self.view).showsVerticalScrollIndicator=NO;
    ((UIScrollView*)self.view).directionalLockEnabled=YES;
    self.tableView.frame=CGRectMake(306, 0, 306, 390);
    [((UIScrollView*)self.view) addSubview:self.tableView];
    
   
    
    
    
    
    
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcelldetail" ofType:@"html"];
    NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    

    infoText=[infoText setWeibo:[(NewFeedData*)_feedData getName]];

    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [infoText release];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // _commentArray=[[NSMutableArray alloc] init];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      [self addOriStatus ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _pageNumber=0;
   [self refresh];
}
- (void)viewDidUnload
{
 
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[_feedStatusCel removeFromSuperview];
    //[_feedStatusCel release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}


- (void)dealloc {
    [_feedData release];
    //[_feedStatusCel release];
    [super dealloc];
}


- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
  
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",_feedData.comments];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:YES];
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort];

    [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;

}

#pragma mark - EGORefresh Method
- (void)refresh {
    
   // [self clearData];
    if ([_feedData getStyle]==0)
    {
        _pageNumber=[_feedData getComment_Count]/10+1;
    }
    else
    {
        _pageNumber=1;
    }
    
    

    
    if(_loading)
        return;
    _loading = YES;

    [self loadData];
    
    


}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}






-(void)loadData
{
    if ([_feedData getStyle]==0)
    {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    StatusCommentData* commentsData=[StatusCommentData insertNewComment:0 Dic:dict inManagedObjectContext:self.managedObjectContext];
                    [_feedData addCommentsObject:commentsData];
                    
                }
                
                if (_pageNumber!=1)
                {
                    _showMoreButton=YES;
                }
                else
                {
                    _showMoreButton=NO;
                }
                
                _loading=NO;
                 [self doneLoadingTableViewData];
      
            }
            
            
            
        }];
        
        
        [renren getComments:[_feedData getActor_ID] status_ID:[_feedData getSource_ID] pageNumber:_pageNumber];
        
    }
    
    else
    {
        WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                
  
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    
                    StatusCommentData* commentsData=[StatusCommentData insertNewComment:1 Dic:dict inManagedObjectContext:self.managedObjectContext];
                    [_feedData addCommentsObject:commentsData]; 
                }
                
                
                
                if ([_feedData.comments count]<[_feedData getComment_Count])
                {
                    _showMoreButton=YES;
                }
                else
                {
                    _showMoreButton=NO;
                }
                _loading=NO;
                [self doneLoadingTableViewData];
                
                
            }
            
            
            
            
            
            
        }];

        [weibo getCommentsOfStatus:[_feedData getSource_ID] page:_pageNumber count:10];
    }
    
    
    
    
}




- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSTimeInterval i = 0;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        i += 0.05;
        [self performSelector:@selector(loadExtraDataForOnScreenRowsHelp:) withObject:indexPath afterDelay:i];
    }
}




- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    
    
    if ([_feedData getStyle]==0)
    {
        _pageNumber--;
    }
    else
    {
        _pageNumber++;
    }
    [self loadData]    ;
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        if (_showMoreButton==YES)
        {
            
            if (indexPath.row==0)
            {
                return 60;
            }
            else
            {
                NSIndexPath* index=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                
               // indexPath=[[indexPath indexPathByRemovingLastIndex] indexPathByRemovingLastIndex];
                return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:index]];
            }
        }
        else
        {
       //     indexPath=[indexPath indexPathByRemovingLastIndex];
            return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        }


    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int number=[super tableView:tableView numberOfRowsInSection:section];
    if (_showMoreButton==NO)
    {
        return number;
    }
    else
    {
        return number+1;
    }
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StatusComentCell = @"StatusCommentCell";
     if (_showMoreButton==NO)
     {
        StatusCommentCell* cell;
        cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
            cell = _commentCel;
        }
        [cell configureCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        return cell;
     }
    else
    {
        if (indexPath.row==0)
        {
          UITableViewCell* cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 306, 60)]; 
           [cell.contentView addSubview:self.loadMoreDataButton];
            return cell;
        }
        else
        {
            StatusCommentCell* cell;
            
            cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
                cell = _commentCel;
            }
            
            NSIndexPath* index=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            
            [cell configureCell:[self.fetchedResultsController objectAtIndexPath:index]];
            return cell;
        }
    };  
  
    
}





    @end
