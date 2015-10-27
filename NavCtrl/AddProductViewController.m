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

- (IBAction)addProduct:(id)sender {
    {
        
        
        NSString *pName = [_productName text ];

        
        NSString *pUrl = [self.productUrl text];
        
        Company* company = self.company;
        
        [[DataAccess sharedData] addProductToCompany:pName :pUrl :company];
        
        [[DataAccess sharedData]saveDataToCompanyList];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
- (void)dealloc {
    [_productName release];
    [_productUrl release];
       [super dealloc];
}
@end
