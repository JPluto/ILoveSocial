//
//  SocialFusionAppDelegate.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-8-8.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialFusionViewController;

@interface SocialFusionAppDelegate : NSObject <UIApplicationDelegate> {
    //NSManagedObjectContext* _manageObjectModel1;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SocialFusionViewController *viewController;
// core data
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;  
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;  
- (NSURL *)applicationDocumentsDirectory;  

@end
