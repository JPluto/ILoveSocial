//
//  NewFeedData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedData.h"


@implementation NewFeedData
@synthesize owner_Name;

-(NSString*)getFeedName
{
    return owner_Name;
}



-(NSString*)getPostMessage
{
    NSString* tempString=@"";
   
    int nameLength=[post_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([post_Name characterAtIndex:i]<256)
        {
            tempString=[tempString stringByAppendingString:@"  "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"    "];
        }
    }
    
    
    
    
   // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@"%@",post_Status] ;
    

}


-(NSString*)getPostName
{
    return post_Name;
}


-(NSString*)getName
{


    //if (description==nil)
    //description=@"";
    
    NSString* tempString=@"";

    
    int nameLength=[owner_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([owner_Name characterAtIndex:i]<256)
        {
              tempString=[tempString stringByAppendingString:@"  "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"    "];
        }
    }


    
    
    
    return [tempString stringByAppendingFormat:@"%@",message]  ;
    
}
-(NSString*)getHeadURL
{
    return owner_Head;
}
-(id)initWithDictionary:(NSDictionary*)feedDic
{
    
    
    NSArray* attachments=[feedDic objectForKey:@"attachment"];
    if ([attachments count]!=0)
    {
        NSDictionary* attachment=[attachments objectAtIndex:0];
        if ([attachment count]!=0)
        {
            post_ID=[[attachment objectForKey:@"owner_id"] retain];
            
            post_Name=[[attachment objectForKey:@"owner_name"] retain];
            
            
            post_Status=[[attachment objectForKey:@"content"] retain];
        }

    }
    
  //  NSLog(@"%@",feedDic);
       
    actor_ID=[[feedDic objectForKey:@"actor_id"] retain];
    
   // title=[feedDic objectForKey:@"title"];
    
   // [title retain];
    
   owner_Head= [[feedDic objectForKey:@"headurl"] retain];
 
    
   // prefix=[feedDic objectForKey:@"prefix"];
   // [prefix retain];
    
    description=[feedDic objectForKey:@"description"];
    [description retain];
    
    owner_Name=[feedDic objectForKey:@"name"];
    [owner_Name retain];
    
    comment_Count=[[[feedDic objectForKey:@"comments"] objectForKey:@"count"] intValue];
    
    likes_Count=[[feedDic objectForKey:@"total_count"] intValue];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    NSString* dateString=[feedDic objectForKey:@"update_time"];
	update_Time=[[form dateFromString: dateString] retain];
    
    
	
    //  NSDate* TempDate=[NSDate dateWithString:@"2011-08-03 21:01:00 +0900"];
   // NSLog(@"%@",update_Time);
    
    // NSDate*         update_Time;
    
    message=[feedDic objectForKey:@"message"];
    [message retain];
    
    return self;
    
}


-(NSDate*)getDate
{
    return update_Time;
}


@end
