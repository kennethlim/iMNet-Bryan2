//
//  ContactsViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController

@synthesize managedObjectContext;
@synthesize rscMgr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    FrameID = 1;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactTableUpdate:) name:@"contactUpdated" object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"contactUpdated" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchContacts setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *fetchedResultArray = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] mutableCopy];
    fetchedContactsArray = fetchedResultArray;
    
    return [fetchedContactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[[fetchedContactsArray objectAtIndex:indexPath.row] isAvailable] boolValue]) {
        [[cell textLabel] setTextColor:[UIColor blackColor]];
    }
    else{
        [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
    }
    
    cell.textLabel.text = [[fetchedContactsArray objectAtIndex:indexPath.row] username];
    cell.detailTextLabel.text = [[fetchedContactsArray objectAtIndex:indexPath.row] address64];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
   //  ContactDetailsViewController *detailViewController = [[ContactDetailsViewController alloc] initWithNibName:@"ContactDetails" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    // [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    selectedIndex = indexPath.row;
}

- (void)contactTableUpdate:(NSNotification *)notification
{
    [self.tableView reloadData];
    // Retrieve information about the document and update the panel
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        Contacts *contactToDelete = [fetchedContactsArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:contactToDelete];
        NSError *error1 = nil;
        if (![managedObjectContext save:&error1]) {
            // Handle the error.
        }
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ContactDetailsSegue"])
	{
		ContactDetailsViewController *contactDetailsViewController = segue.destinationViewController;
        contactDetailsViewController.currentContact = [fetchedContactsArray objectAtIndex:selectedIndex];
        contactDetailsViewController.managedObjectContext = managedObjectContext;
	}
}


- (IBAction)contactDiscovery:(id)sender {
    //send node discover AT command to xbee    
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchContacts setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *fetchedResultArray = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] mutableCopy];
    
    for (int i =0; i<[fetchedResultArray count]; i++) {
        [[fetchedResultArray objectAtIndex:i] setIsAvailable:[NSNumber numberWithBool:FALSE]];
    }
    
    NSError *error1 = nil;
    if (![managedObjectContext save:&error1]) {
        // Handle the error.
    }
    
    [self.tableView reloadData];
    
    XbeeTx *XbeeObj = [XbeeTx new];
    [XbeeObj ATCommand:@"ND" withFrameID:FrameID];   //set up ATCommand for node discover
    
    NSArray *sendPacket = [XbeeObj txPacket];
    for ( int i = 0; i< (int)[sendPacket count]; i++ ) {
        txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue]; 
    }
    int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
    
    
}
    

@end
