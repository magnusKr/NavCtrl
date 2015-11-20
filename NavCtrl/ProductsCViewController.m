//
//  ProductsCViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 13/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ProductsCViewController.h"

@interface ProductsCViewController ()

@end

@implementation ProductsCViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductsCVCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
    
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0;
    longPressRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:longPressRecognizer];
    
    [longPressRecognizer release];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.company.companyName;
    [self reload];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reload
{
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return[self.company.listOfCompanyProducts count];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    Product *product = [self.company.listOfCompanyProducts objectAtIndex: indexPath.row];
    [cell.productImage setImage:[UIImage imageNamed:product.productImage]];
    cell.productName.text = product.productName;

    
    return cell;
}



-(void) addProduct
{
    self.addProductViewController = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    self.addProductViewController.company = self.company;
    
    [self.navigationController pushViewController:self.addProductViewController animated:YES];

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.productDetailsViewController = [[[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil] autorelease];
    
    Product *product = [self.company.listOfCompanyProducts objectAtIndex:indexPath.row];
    
    self.productDetailsViewController.productUrlToLoad =  product.productUrl;
    
    [self.navigationController pushViewController:self.productDetailsViewController animated:YES];
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded){
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    }else{
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Update Product"
                                      message:@"Remove or update product details"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Delete"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [[DataAccess sharedData]deleteCompanyProducts:[indexPath row] :self.company];
                                 [self reload];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Update"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     self.editProductViewController = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];
                                     self.editProductViewController.productIndex = indexPath.row;
                                     self.editProductViewController.company = self.company;
                                     [self.navigationController pushViewController:self.editProductViewController animated:YES];
                                     

                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];        
        [self presentViewController:alert animated:YES completion:nil];

    }
}


- (void)dealloc {
    
    [_company release];
    [_editProductViewController release];
    [_productDetailsViewController release];
    [_addProductViewController release];
    [super dealloc];
}


@end
