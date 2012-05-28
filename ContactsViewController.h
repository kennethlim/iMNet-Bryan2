//
//  ContactsViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"

#import "FirstViewController.h"
#import "ContactDetailsViewController.h"

@interface ContactsViewController : UITableViewController{
    
    //core data instance variables
    NSManagedObjectContext *managedObjectContext;   
    
    //redpark cable instance variables
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];

    
    NSMutableArray *fetchedContactsArray;
    int selectedIndex;
    
}

- (IBAction)contactDiscovery:(id)sender;

- (void)contactTableUpdate:(NSNotification *)notification;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) RscMgr *rscMgr;

@end
