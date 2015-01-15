//
//  BBUsersTableViewController.m
//  BodyBuildingDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "BBUsersTableViewController.h"

#import "BBUserTableViewCell.h"
#import "BBReloadTableViewCell.h"

#import "BBUserDetailsController.h"
#import "BBNotesPreviewViewController.h"

#import "BBUser+Accessors.h"
#import "BBUserSortMaker.h"

static NSString *kUserCellIdentifier = @"kUserCellIdentifier";
static NSString *kReloadCellIdentifier = @"kReloadCellIdentifier";

@interface BBUsersTableViewController ()<NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, BBUserTableViewCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSUInteger lastRequestedPage;
@property (nonatomic) NSMutableDictionary *imagesForUsers;

@property (nonatomic) BBUserSortOption currentSortOrder;
@property (nonatomic, strong) BBNotesPreviewViewController *notesPreviewController;
@end

@implementation BBUsersTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.currentSortOrder = BBUserSortOptionDefault;
    self.imagesForUsers = [[NSMutableDictionary alloc] init];
    self.lastRequestedPage = 0;

    self.title = NSLocalizedString(@"Users", @"users table title");
    
    [self registerCellNibs];

    [self addSortButton];
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

- (void)registerCellNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BBUserTableViewCell" bundle:nil] forCellReuseIdentifier:kUserCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BBReloadTableViewCell" bundle:nil] forCellReuseIdentifier:kReloadCellIdentifier];
}

- (void)addSortButton
{
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sort", @"sort button title") style:UIBarButtonItemStylePlain target:self action:@selector(showSortOptions)];
    
    self.navigationItem.rightBarButtonItem = sortButton;
}

- (void)dataLoaded
{
    self.lastRequestedPage += 1;
    //Check if the reload cell is still on screen after fetch, this occurs when results are not enough to fill screen.
    BBReloadTableViewCell *lastCell = [[self.tableView visibleCells] lastObject];
    if([lastCell isKindOfClass:[BBReloadTableViewCell class]]){
        [self loadDataForPage:self.lastRequestedPage + 1];
    }
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


#pragma mark - Getters

- (NSFetchRequest*)fetchRequestForSortOrder:(BBUserSortOption)sortOption
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [BBUserSortMaker sortDescriptorForOption:sortOption];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    return fetchRequest;
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
        NSFetchRequest *fetchRequest = [self fetchRequestForSortOrder:self.currentSortOrder];
        
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
        if(![self hasMorePages]){
            [cell stopLoading];
        }
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
    if([self indexPathIsLastRowInTable:tableView indexPath:indexPath] && [self hasMorePages]){
        [(BBReloadTableViewCell*)cell startLoading];
        
        [self loadDataForPage:self.lastRequestedPage + 1];
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
    cell.indexPath = indexPath;
    cell.delegate = self;
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


- (void)loadDataForPage:(NSUInteger)page
{
    if([self hasMorePages]){
        
        [BBApi getUsersForPage:page sortOrder:[BBUserSortMaker sortDescriptorForOption:self.currentSortOrder] completion:^(NSDictionary *data, NSError *error) {
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

- (BOOL)indexPathIsLastRowInTable:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath
{
    return indexPath.row == [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
}

- (void)purgeLocalUserData
{
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [self.managedObjectContext executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [self.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

# pragma mark - Sorting

- (void)showSortOptions
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIAlertView *options = [BBUserSortMaker alertViewOfOptions];
        options.delegate = self;
        [options show];
    }else{
        UIActionSheet *actionSheet = [BBUserSortMaker actionSheetOfOptions];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex){
        [self updateSortForIndex:buttonIndex];

    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex){
        [self updateSortForIndex:buttonIndex];
    }
}

- (void)updateSortForIndex:(NSInteger)index
{
    self.currentSortOrder = index;
    self.fetchedResultsController = nil;
    [self fetchResults];
    [self.tableView reloadData];
    
    if([self hasMorePages]){
        // REset data Not sure really best way to do this
        self.lastRequestedPage = 0;
        [self purgeLocalUserData];
    }else {
        
    }
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

#pragma mark - BBUserTableViewCellDelegate

- (void)notesButtonPressedAtIndexPath:(NSIndexPath *)indexPath
{
    BBUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.notesPreviewController = [[BBNotesPreviewViewController alloc] init];
    self.notesPreviewController.notes = user.notes;
    self.notesPreviewController.view.frame = self.tableView.window.bounds;
    
    [self.tableView.window addSubview:self.notesPreviewController.view];
}
@end
