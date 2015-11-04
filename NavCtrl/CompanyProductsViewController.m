//
//  ChildViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyProductsViewController.h"


@interface CompanyProductsViewController ()

@end

@implementation CompanyProductsViewController

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
 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
    
    UIBarButtonItem *editButton = self.editButtonItem;
    
    NSArray *buttonArray = [NSArray arrayWithObjects:addButton,editButton, nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.company.companyName;
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

    
    return[self.company.listOfCompanyProducts count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Product *product = [self.company.listOfCompanyProducts objectAtIndex: indexPath.row];
                        
    cell.textLabel.text = product.productName;
    cell.imageView.image = [UIImage imageNamed:product.productImage];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    [lpgr release];
    
    return cell;
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture{
    
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        CGPoint p = [gesture locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        EditProductViewController *editProductVC = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];
        editProductVC.productIndex = indexPath.row;
        editProductVC.company = self.company;
        [self.navigationController pushViewController:editProductVC animated:YES];
        
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
   
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[DataAccess sharedData]deleteCompanyProducts:[indexPath row] :self.company];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    [[DataAccess sharedData]moveProductRow:fromIndexPath.row :toIndexPath.row :self.company];
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
  
    return YES;
}


/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductViewController *detailViewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    
    Product *product = [self.company.listOfCompanyProducts objectAtIndex:indexPath.row];
 
    
    detailViewController.someUrlToLoad =  product.productUrl;

    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    [detailViewController release];
}


-(void) addProduct
{
    AddProductViewController *addProductVC = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    addProductVC.company = self.company;
    
    [self.navigationController pushViewController:addProductVC animated:YES];
    
    [addProductVC release];

}
-(void)dealloc
{
    [_company release];
    
    [super dealloc];
    
}


@end
