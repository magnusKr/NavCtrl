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




- (void)viewDidLoad {
    [super viewDidLoad];
    
  
     [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateQuotes) userInfo:nil repeats:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CompanyCVCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCompany)];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload
{
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[DataAccess sharedData] getNumberOfCompanies];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
      CompanyCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   cell.backgroundColor = [UIColor whiteColor];
    
    Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    
    [cell.ImageCell setImage:[UIImage imageNamed:company.companyLogo]];
    cell.companyName.text =  company.companyName;
    cell.companyQuote.text = company.compnayStockPrice;
    

    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        Company *company = [[DataAccess sharedData] getCompany:[indexPath row]];
    
        self.childVC = [[ProductsCViewController alloc] initWithNibName:@"ProductsCViewController" bundle:nil];

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

- (void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil)
    {
        NSLog(@"couldn't find index path");
    }
    else {

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
                                     
                                EditCompanyViewController *editCompanyVC = [[EditCompanyViewController alloc] initWithNibName:@"EditCompanyViewController" bundle:nil];
                                editCompanyVC.companyIndex = indexPath.row;
                                   
                                [self.navigationController pushViewController:editCompanyVC animated:YES];
                                [editCompanyVC release];
                                     //[alert dismissViewControllerAnimated:YES completion:nil];
                                     
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

@end
