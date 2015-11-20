//
//  AddProductViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 20/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "AddProductViewController.h"

@interface AddProductViewController ()

- (IBAction)addProduct:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *productName;
@property (retain, nonatomic) IBOutlet UITextField *productUrl;

@end

@implementation AddProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)addProduct:(id)sender
{
        NSString *pName = [self.productName text ];
        NSString *pUrl = [self.productUrl text];
        Company* company = self.company;
        
        [[DataAccess sharedData] addProductToCompany:pName :pUrl :company];
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_productName release];
    [_productUrl release];
    [super dealloc];
}
@end
