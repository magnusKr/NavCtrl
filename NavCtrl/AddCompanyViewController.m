//
//  AddCompanyViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 20/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "AddCompanyViewController.h"

@interface AddCompanyViewController ()

@property (retain, nonatomic) IBOutlet UITextField *companyName;
@property (retain, nonatomic) IBOutlet UITextField *companyCode;


- (IBAction)addCompany:(id)sender;

@end

@implementation AddCompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)addCompany:(id)sender
{
    NSString* companyString = self.companyName.text;
    NSString* companyCodeString = self.companyCode.text;
    
    if([companyCodeString  isEqual: @""])
        companyCodeString = @"-";
    
    [[DataAccess sharedData] addCompany:companyString :companyCodeString : self.delegate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {

    [_companyName release];
    [_companyCode release];
    [super dealloc];
}


@end
