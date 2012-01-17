//
//  NewFeedListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedListController.h"
#import "NavigationToolBar.h"
#import <QuartzCore/QuartzCore.h>
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "NewFeedUploadPhoto+Addition.h"
#import "NewFeedShareAlbum+Addition.h"
#import "NewFeedSharePhoto+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "NewFeedBlog.h"
#import "StatusDetailController.h"
#import "UIImage+Addition.h"
#import "ShowImage.h"
static NSInteger SoryArrayByTime(NewFeedRootData* data1, NewFeedRootData* data2, void *context)
{
    return ([data2.update_Time compare:data1.update_Time]);
}



@implementation NewFeedListController






- (void)viewDidLoad
{
    [super viewDidLoad];
    // if(_type == RelationshipViewTypeRenrenFriends && self.currentRenrenUser.friends.count > 0)
    //  return;
    //return;
    _pageNumber=0;
    _indexPath=nil;
    
    
    _cellHeightHelper=[[NewFeedCellHeight alloc] init];
    [_cellHeightHelper myinit:self];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}

- (void)dealloc {
    [super dealloc];
}

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedRootData" inManagedObjectContext:self.managedObjectContext]];
    //  NSLog(<#NSString *format, ...#>)[request entity];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
    NSSortDescriptor *sort2;
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@||SELF IN %@", self.currentWeiboUser.newFeed, self.currentRenrenUser.newFeed];
    //  sort = [[NSSortDescriptor alloc] initWithKey:@"1" ascending:YES];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:NO];
    sort2 = [[NSSortDescriptor alloc] initWithKey:@"get_Time" ascending:YES];
    
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort2, sort, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    //   [request setSortDescriptors:nil];
    [request setPredicate:predicate];
   // NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    // [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;
}

#pragma mark - EGORefresh Method
- (void)refresh {
    NSLog(@"refresh!");
    _pageNumber=0;
    //  [self hideLoadMoreDataButton];
    if (_currentTime!=nil)
    {
        [_currentTime release];
    }
    [self clearData];
    [self loadMoreData];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}


- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                
                NSLog(@"%@",dict);
                int scrollHeight =[_cellHeightHelper getHeight:dict style:1];
              
                NewFeedData* data = [NewFeedData insertNewFeed:1 height:scrollHeight getDate:_currentTime Owner:self.currentWeiboUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                
                [self.currentWeiboUser addNewFeedObject:data];
                
            }
            

            [self showLoadMoreDataButton];
            [self doneLoadingTableViewData];
            
            _loading = NO;
        }
    }];
    
    [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
    
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


- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];
    
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                
                
                
                       int scrollHeight =[_cellHeightHelper getHeight:dict style:0];
                // NSLog(@"%@",dict);
                
                
                if (([[dict objectForKey:@"feed_type"] intValue]==20)||([[dict objectForKey:@"feed_type"] intValue]==21))
                {
              
                    
           
                    
                    NewFeedBlog* data = [NewFeedBlog insertNewFeed:0  height:scrollHeight  getDate:_currentTime  Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];

                    [self.currentRenrenUser addNewFeedObject:data]; 
                }
                else if ([[dict objectForKey:@"feed_type"] intValue]==30)
                {
                    
                    NewFeedUploadPhoto* data = [NewFeedUploadPhoto insertNewFeed:0   getDate:_currentTime  Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                    
                    [self.currentRenrenUser addNewFeedObject:data]; 
                }
                else if ([[dict objectForKey:@"feed_type"] intValue]==33)
                {
                    NewFeedShareAlbum* data = [NewFeedShareAlbum insertNewFeed:0  height:scrollHeight getDate:_currentTime  Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                    
                    [self.currentRenrenUser addNewFeedObject:data]; 
                }
                else if ([[dict objectForKey:@"feed_type"] intValue]==32)
                {
                    NewFeedSharePhoto* data = [NewFeedSharePhoto insertNewFeed:0    height:scrollHeight  getDate:_currentTime  Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                    
                    [self.currentRenrenUser addNewFeedObject:data]; 
                }
                else
                {
                    
                    NewFeedData* data = [NewFeedData insertNewFeed:0  height:scrollHeight getDate:_currentTime  Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                    
                    
                    [self.currentRenrenUser addNewFeedObject:data];
                }
            }
            
            
            
            
            [self showLoadMoreDataButton];
            [self doneLoadingTableViewData];
            _loading = NO;
        }
    }];
    
    [renren getNewFeed:_pageNumber];
    
    
}

- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    _pageNumber++;
    
    _currentTime=[[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    [self loadMoreRenrenData];
    [self loadMoreWeiboData];
    
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath==nil)
    {
        return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else
    {
        if ([indexPath compare:_indexPath])
            
        {
            return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        }
        else
        {
            return 389;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}




-(void)showImage:(NSString*)stringURL
{

 
    
    //     [self.view addSubview:tempImage];

   // [tempImage startAnimation];
    
    
    Image* image = [Image imageWithURL:stringURL inManagedObjectContext:self.managedObjectContext];
    if (!image)
    {
    [UIImage loadImageFromURL:stringURL completion:^{
            Image *image1 = [Image imageWithURL:stringURL inManagedObjectContext:self.managedObjectContext];
            
        
        
        ShowImage* tempImage=[[ShowImage alloc] initWithImage:[UIImage imageWithData:image1.imageData.data]];
        tempImage.frame=CGRectMake(0, 0, 320, 480);
        tempImage.alpha=0;
        [[UIApplication sharedApplication].keyWindow addSubview:tempImage];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            tempImage.alpha = 1;
        } completion:nil];
        
        
        } cacheInContext:self.managedObjectContext];
    }
    else
    {
    
        
    }
    
    
    
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *StatusCell = @"NewFeedStatusCell";
    static NSString *RepostStatusCell=@"NewFeedRepostCell";
    static NSString *BlogCell=@"NewFeedBlogCell";
    static NSString *DetailCell=@"DetailCell";
    if ([indexPath compare:_indexPath])
    {
        NewFeedStatusCell* cell;
        
        //  if ([self.fetchedResultsController objectAtIndexPath:indexPath])
        NewFeedRootData* a= [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([a class]==[NewFeedData class])
        {
            if ([a getPostName]==nil)
            {
                cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:StatusCell];
                if (cell == nil) {
                    [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusCell" owner:self options:nil];
                    cell = _feedStatusCel;
                    

                }
            }
            
            else
            {
                cell = (NewFeedStatusWithRepostcell *)[tableView dequeueReusableCellWithIdentifier:RepostStatusCell];
                if (cell == nil) {
                    [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusWithRepostcell" owner:self options:nil];
                    cell = _feedRepostStatusCel;
                }
                
            }
        }
        
        else if ([a class]==[NewFeedUploadPhoto class]||[a class]==[NewFeedShareAlbum class]||[a class]==[NewFeedSharePhoto class] )
        {
            cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:StatusCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusCell" owner:self options:nil];
                cell = _feedStatusCel;
                
            }
        }
        
        else if ([a class]==[NewFeedBlog class])
        {
            cell=(NewFeedBlogCell*)[tableView dequeueReusableCellWithIdentifier:BlogCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedBlogCell" owner:self options:nil];
                cell = _newFeedBlogCel;
            }
        }
        
        
        
        
        [cell configureCell:a];
        
        [cell setList:self];
        
        
        
        NSData *imageData = nil;
        if([Image imageWithURL:a.owner_Head inManagedObjectContext:self.managedObjectContext]) {
            imageData = [Image imageWithURL:a.owner_Head inManagedObjectContext:self.managedObjectContext].imageData.data;
        }
        if(imageData != nil) {
            //   cell.headImageView.image = [UIImage imageWithData:imageData];
        }
        
        if ([a class]==[NewFeedData class])
        {
            NewFeedData* data2=(NewFeedData*)a;
            if (data2.pic_URL!=nil)
            {
                if([Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext]) {
                    imageData = [Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext].imageData.data;
                }
                if(imageData != nil) {
                    //         cell.picView.image = [UIImage imageWithData:imageData];
                    //       cell.picView.frame=CGRectMake(cell.picView.frame.origin.x, cell.picView.frame.origin.y,(cell.picView.frame.size.height/cell.picView.image.size.height)*cell.picView.image.size.width, cell.picView.frame.size.height);
                }
            }
        }
        return cell;
    }
    else//展开时的cell
    {
        NewFeedDetailViewCell* cell;
        NewFeedData* a= [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([a class]==[NewFeedData class])
        {
            
            
            [[NSBundle mainBundle] loadNibNamed:@"NewFeedDetailViewCell" owner:self options:nil];
            cell = _newFeedDetailViewCel;
            
            [cell initWithFeedData:a context:self.managedObjectContext];
            
        }
        return cell;
    }
    
    
    
}







- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    NewFeedRootData *data = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext];
    if (!image)
    {
        NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [UIImage loadImageFromURL:data.owner_Head completion:^{
            Image *image1 = [Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext];
            
            [statusCell loadImage:image1.imageData.data];
            
        } cacheInContext:self.managedObjectContext];
        
    }
    
    else
    {
        NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [statusCell loadImage:image.imageData.data];
        
    }
    
    if ([data class]==[NewFeedUploadPhoto class])
    {
        NewFeedUploadPhoto* data2=(NewFeedUploadPhoto*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
    if ([data class]==[NewFeedShareAlbum class])
    {
        NewFeedShareAlbum* data2=(NewFeedShareAlbum*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
    if ([data class]==[NewFeedSharePhoto class])
    {
        NewFeedSharePhoto* data2=(NewFeedSharePhoto*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
     if ([data class]==[NewFeedData class])
     {
         NewFeedData* data2=(NewFeedData*)data;
         if (data2.pic_URL!=nil)
         {
         image = [Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext];
         if (!image)
         {
             NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
             [UIImage loadImageFromURL:data2.pic_URL completion:^{
                 Image *image1 = [Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext];
                 
                 [statusCell loadPicture:image1.imageData.data];
                 
             } cacheInContext:self.managedObjectContext];
         }
         else
         {
             NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
             
             [statusCell loadPicture:image.imageData.data];
             
         }
         }
     }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadExtraDataForOnscreenRows];
}




- (void)configureToolbar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton-highlight.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(12, 12, 31, 34);
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    NSMutableArray *toolBarItems = [NSMutableArray array];
    [toolBarItems addObject:backButtonItem];
    self.toolbarItems = nil;
    self.toolbarItems = toolBarItems;
    ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView;
}


- (void)clearData
{
    
    _firstLoadFlag = YES;
    [self.renrenUser removeNewFeed:self.renrenUser.newFeed];
    
    [self.weiboUser removeNewFeed:self.weiboUser.newFeed];
    
}


-(void)exposeCell:(NSIndexPath*)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].selected=false;
    self.tableView.allowsSelection=false;
    //NSLog(@"%@",[self.fetchedResultsController objectAtIndexPath:indexPath]);
    
    //_openedCell=indexPath.row;
    _indexPath=[indexPath retain];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled=FALSE;
}


-(IBAction)resetToNormalList
{
    
    self.tableView.allowsSelection=YES;
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.tableView.scrollEnabled=true;
    NSIndexPath* tempIndex=[_indexPath retain];
    [_indexPath release];
    _indexPath=nil;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndex] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:tempIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tempIndex release];
}




@end
