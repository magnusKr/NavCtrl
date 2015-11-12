//
//  qcdDemoViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"



@interface CompanyViewController ()

@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCompany)];
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[DataAccess sharedData] getCompanyQuoteWithDelegate:self];
    
    self.title = @"Mobile device makers";
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    // if you use this, you dont need to check deque and allocatacte cell in cellAtIndexPath
    //[self.tableView registerClass:<#(nullable Class)#> forCellReuseIdentifier:<#(nonnull NSString *)#>];
    
}
-(void)reload{

    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self.tableView reloadData];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  [[DataAccess sharedData] getNumberOfCompanies];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    
    
    // every time cellForRowAtIndexPath gets called, UILongPressGestureRecognizer is set to tableview
    // it should not be in this method as it is not attached to cell
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    [lpgr release];
        
    cell.textLabel.text = company.companyName;
    cell.imageView.image = [UIImage imageNamed:company.companyLogo];
    cell.detailTextLabel.text = company.compnayStockPrice;


    
    return cell;
   
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture{
   
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        CGPoint p = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        EditCompanyViewController *editCompanyVC = [[EditCompanyViewController alloc] initWithNibName:@"EditCompanyViewController" bundle:nil];
        editCompanyVC.companyIndex = indexPath.row;
        
        [self.navigationController pushViewController:editCompanyVC animated:YES];
        [editCompanyVC release];
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[DataAccess sharedData] deleteCompany:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[DataAccess sharedData] moveCompanyRow:fromIndexPath.row :toIndexPath.row];

}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    // extra method [[DataAccess sharedData] getCompanyName:company];
    //self.childVC.title = [[DataAccess sharedData] getCompanyName:company]; // this should be done inside childvc
    self.childVC.company = company;
    
    [self.navigationController pushViewController:self.childVC animated:YES];
}

-(void) addCompany
{
    AddCompanyViewController *addCompanyVC = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    addCompanyVC.delegate = self;
    
    [self.navigationController pushViewController:addCompanyVC animated:YES];
    
    [addCompanyVC release];
}


@end
