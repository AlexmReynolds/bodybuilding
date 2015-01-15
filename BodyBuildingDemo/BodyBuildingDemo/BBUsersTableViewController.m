//
//  BBUsersTableViewController.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUsersTableViewController.h"
#import "BBUserFetchedResultsController.h"

#import "BBUserTableViewCell.h"
#import "BBReloadTableViewCell.h"

#import "BBUserDetailsController.h"

#import "BBUser+Accessors.h"

static NSString *kUserCellIdentifier = @"kUserCellIdentifier";
static NSString *kReloadCellIdentifier = @"kReloadCellIdentifier";

@interface BBUsersTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSUInteger lastRequestedPage;
@property (nonatomic) NSMutableDictionary *imagesForUsers;
@end

@implementation BBUsersTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.imagesForUsers = [[NSMutableDictionary alloc] init];
    self.lastRequestedPage = 0;

    self.title = NSLocalizedString(@"Users", @"users table title");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BBUserTableViewCell" bundle:nil] forCellReuseIdentifier:kUserCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BBReloadTableViewCell" bundle:nil] forCellReuseIdentifier:kReloadCellIdentifier];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchResults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchResults) name:NSManagedObjectContextWillSaveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchResults) name:NSManagedObjectContextDidSaveNotification object:nil];
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)loadDataForPage:(NSUInteger)page
{
    if([self hasMorePages]){
        [BBApi getUsersForPage:page completion:^(NSDictionary *data, NSError *error) {
            NSLog(@"data %@", data);
            if(data){
                for(NSDictionary *userData in data){
                    [BBUser createOrUpdatedWithDictionary:userData inContext:self.managedObjectContext];
                }
                NSError *saveError = nil;
                [self.managedObjectContext save:&saveError];
                if(saveError != nil){
                    NSLog(@"save Error %@", saveError);
                }
                if(data.count == 10){
                    [self dataLoaded];
                }else {
                    //NO MORE RESULTS
                    [self noMorePages];
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error modal title") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"error modal cancel button") otherButtonTitles:nil];
                [alert show];
            }
        }];
    }

}
- (void)dataLoaded
{
    self.lastRequestedPage += 1;
}

- (void)noMorePages
{
    self.lastRequestedPage = NSNotFound;
    BBReloadTableViewCell *lastCell = [[self.tableView visibleCells] lastObject];
    if([lastCell isKindOfClass:[BBReloadTableViewCell class]]){
        [lastCell stopLoading];
    }
}

- (BOOL)hasMorePages
{
    return self.lastRequestedPage != NSNotFound;
}

- (void)fetchResults
{
    NSError *fetchError = nil;
    if (![self.fetchedResultsController performFetch:&fetchError]) {
        if(fetchError != nil){
            NSLog(@"fetch error:%@", [fetchError userInfo]);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext == nil){
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController == nil){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"id" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                       cacheName:nil];
        theFetchedResultsController.delegate = self;
        _fetchedResultsController = theFetchedResultsController;
    }
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self indexPathIsLastRowInTable:tableView indexPath:indexPath]){
        BBReloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReloadCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }else {
        BBUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellIdentifier forIndexPath:indexPath];
        [self configureUserCell:cell AtIndexPath:indexPath];
        
        return cell;
    }

}

#pragma mark - Table Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self indexPathIsLastRowInTable:tableView indexPath:indexPath]){
        [(BBReloadTableViewCell*)cell startLoading];
        
        [self loadDataForPage:self.lastRequestedPage++];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self indexPathIsLastRowInTable:tableView indexPath:indexPath]){
        // DO nothing
    }else {
        BBUserDetailsController *details = [[BBUserDetailsController alloc] initWithNibName:@"BBUserDetailsController" bundle:nil];
        BBUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        details.user = user;
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self indexPathIsLastRowInTable:tableView indexPath:indexPath]){
        return 44;
    }else {
        BBUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        return [BBUserTableViewCell cellHeightInTableView:tableView forUser:user];
    }
    
}

#pragma mark - Helpers

- (void)configureUserCell:(BBUserTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    BBUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.user = user;
    // Configure the cell..
    
    if (self.imagesForUsers[indexPath]) {
        cell.avatarImageView.image = self.imagesForUsers[indexPath];
    } else {
        // set default user image while image is being downloaded
        cell.avatarImageView.image = [UIImage imageNamed:@"batman.png"];
        
        // download the image asynchronously
        [cell.avatarImageView downloadImageWithURL:[NSURL URLWithString:user.profilePicUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.avatarImageView.image = image;
                
                // cache the image for use later (when scrolling up)
                self.imagesForUsers[indexPath] = image;
            }
        }];
    }
}

- (BOOL)indexPathIsLastRowInTable:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath
{
    return indexPath.row == [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
}

#pragma mark - Fetch Results Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //  [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default: // Handle all other cases
            // No op.
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
