//
//  CompanyCViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 12/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CompanyCViewController.h"

@interface CompanyCViewController ()

@end

@implementation CompanyCViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self updateQuotes];
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateQuotes) userInfo:nil repeats:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CompanyCVCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCompany)];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0;
    longPressRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:longPressRecognizer];
    
    [longPressRecognizer release];
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
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
    return [[DataAccess sharedData] getNumberOfCompanies];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CompanyCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.backgroundColor = [UIColor whiteColor];
    
    Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    
    [cell.ImageCell setImage:[UIImage imageNamed:company.companyLogo]];
    cell.companyName.text =  company.companyName;
    cell.companyQuote.text = company.compnayStockPrice;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    
    self.productsViewController = [[ProductsCViewController alloc] initWithNibName:@"ProductsCViewController" bundle:nil];

    self.productsViewController.company = company;
    
    [self.navigationController pushViewController:self.productsViewController animated:YES];
    
   
}

-(void) addCompany
{
    self.addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    self.addCompanyViewController.delegate = self;

    [self.navigationController pushViewController:self.addCompanyViewController animated:YES];


}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil)
    {
        NSLog(@"couldn't find index path");
    }
    else
    {

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Update Company"
                                      message:@"Remove or update company details"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Delete"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [[DataAccess sharedData] deleteCompany:indexPath.row];
                                 [self reload];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Update"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                self.editCompanyViewController = [[EditCompanyViewController alloc] initWithNibName:@"EditCompanyViewController" bundle:nil];
                                self.editCompanyViewController.companyIndex = indexPath.row;
                                   
                                [self.navigationController pushViewController:self.editCompanyViewController animated:YES];
                                

                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)updateQuotes
{
   
    [[DataAccess sharedData] getCompanyQuoteWithDelegate:self];

}

- (void)dealloc {
    
    [_productsViewController release];
    [_addCompanyViewController release];
    [_editCompanyViewController release];
    [super dealloc];
}

@end
