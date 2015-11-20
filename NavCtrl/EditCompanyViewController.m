//
//  EditCompanyViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 21/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "EditCompanyViewController.h"

@interface EditCompanyViewController ()

@end

@implementation EditCompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.company = [[DataAccess sharedData] getCompany:self.companyIndex];
    self.companyName.text = self.company.companyName;
    [self.companyLogo setImage:[UIImage imageNamed:self.company.companyLogo]];
    self.companyLogoUrl.text = self.company.companyLogo;
    self.companyCode.text = self.company.compnayCode;
    self.stockPrice.text = self.company.compnayStockPrice;
}

- (IBAction)updateCompanyButton:(id)sender
{
 
    self.company.companyName = self.companyName.text;
    self.company.companyLogo = self.companyLogoUrl.text;
    self.company.compnayCode = self.companyCode.text;
    self.company.compnayStockPrice = self.stockPrice.text;
    
    if([[DataAccess sharedData] updateCompanyDetails:self.company andIndex:self.companyIndex])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [_companyName release];
    [_companyLogo release];
    [_companyLogoUrl release];
    [_companyCode release];
    [_stockPrice release];
    [super dealloc];
}

@end
