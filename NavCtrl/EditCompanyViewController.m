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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    Company *company;
    company = [[DataAccess sharedData] getCompany:self.companyIndex];
    
    self.companyName.text = company.companyName;
    [self.companyLogo setImage:[UIImage imageNamed:company.companyLogo]];

    
    self.companyLogoUrl.text = company.companyLogo;
}

- (IBAction)updateCompanyButton:(id)sender {
    
   
   if([[DataAccess sharedData] updateCompanyDetails: self.companyName.text :self.companyLogoUrl.text :self.companyIndex])
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_companyName release];
    [_companyLogo release];
    [_companyLogoUrl release];
    [super dealloc];
}

@end
