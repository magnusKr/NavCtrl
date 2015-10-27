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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)addCompany:(id)sender
{
    NSString* companyString = self.companyName.text;
    [[DataAccess sharedData] addCompany:companyString :self.companyCode.text : self.delegate];
    
     [[DataAccess sharedData]saveDataToCompanyList];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {

    [_companyName release];
    [_companyCode release];
    [super dealloc];
}


@end
