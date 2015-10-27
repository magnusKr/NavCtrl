//
//  ChildViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ChildViewController.h"


@interface ChildViewController ()

@end

@implementation ChildViewController

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

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
    
    UIBarButtonItem *editButton = self.editButtonItem;
    
    NSArray *buttonArray = [NSArray arrayWithObjects:addButton,editButton, nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return[self.company.listOfCompanyProducts count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Product *product = [[DataAccess sharedData]getCompanyProducts:self.company :[indexPath row]];
                        
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
         [[DataAccess sharedData]saveDataToCompanyList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
   // else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //}
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Product *productToMove = [[DataAccess sharedData]getCompanyProducts:self.company :fromIndexPath.row];
    
    [[DataAccess sharedData]deleteCompanyProducts:fromIndexPath.row :self.company];
    
    [[DataAccess sharedData]insertCompanyProducts:self.company :productToMove :toIndexPath.row];
    
     [[DataAccess sharedData]saveDataToCompanyList];
    
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
    ProductsViewController *detailViewController = [[ProductsViewController alloc] initWithNibName:@"ProductsViewController" bundle:nil];
    
    Product *product = [[DataAccess sharedData]getCompanyProducts:self.company :indexPath.row];
    
    
    detailViewController.someUrlToLoad =  product.productUrl;

    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [ProductsViewController release];
//    [product release];
}


-(void) addProduct
{
    AddProductViewController *addProductVC = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    addProductVC.company = self.company;
    
    [self.navigationController pushViewController:addProductVC animated:YES];
}
-(void)dealloc
{
    [AddProductViewController release];
    [_company release];
    
    [super dealloc];
    
}


@end
