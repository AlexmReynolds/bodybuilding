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

#import "BBUser.h"

static NSString *kUserCellIdentifier = @"kUserCellIdentifier";
static NSString *kReloadCellIdentifier = @"kReloadCellIdentifier";

@interface BBUsersTableViewController ()

@property (nonatomic, strong) BBUserFetchedResultsController *fetchedResultsController;

@end

@implementation BBUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = NSLocalizedString(@"Users", @"users table title");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BBUserTableViewCell" bundle:nil] forCellReuseIdentifier:kUserCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BBReloadTableViewCell" bundle:nil] forCellReuseIdentifier:kReloadCellIdentifier];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (BBUserFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController == nil){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        BBUserFetchedResultsController *theFetchedResultsController =
        [[BBUserFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                       cacheName:nil];
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
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellIdentifier forIndexPath:indexPath];
    BBUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.detailTextLabel.text = user.name;
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BBUserTableViewCell cellHeightInTableView:tableView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
