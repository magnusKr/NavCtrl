//
//  EditProductViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 21/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "EditProductViewController.h"

@interface EditProductViewController ()

@end

@implementation EditProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:(BOOL)animated];
    Product *product;
    product = [self.company.listOfCompanyProducts objectAtIndex:self.productIndex];
    self.productName.text = product.productName;
    self.productUrl.text = product.productUrl;
    self.productImageUrl.text = product.productImage;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)updateProductButton:(id)sender
{
    
    Product *product;
    product = [self.company.listOfCompanyProducts objectAtIndex:self.productIndex];
    
    product.productName = self.productName.text;
    product.productUrl = self.productUrl.text;
    product.productImage = self.productImageUrl.text;
    
    if([[DataAccess sharedData] updateProductDetails:product :self.company])

        [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [_productImage release];
    [_productName release];
    [_productUrl release];
    [_productImage release];
    [super dealloc];
}

@end
