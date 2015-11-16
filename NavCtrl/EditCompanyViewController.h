//
//  EditCompanyViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 21/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyCViewController.h"
@interface EditCompanyViewController : UIViewController
@property NSUInteger companyIndex;
@property (retain, nonatomic) IBOutlet UITextField *companyName;
@property (retain, nonatomic) IBOutlet UIImageView *companyLogo;
@property (retain, nonatomic) IBOutlet UILabel *companyLogoUrl;

@property (retain, nonatomic) IBOutlet UILabel *companyCode;
@property (retain, nonatomic) IBOutlet UILabel *stockPrice;

@property (retain, nonatomic) Company* company;

- (IBAction)updateCompanyButton:(id)sender;

@end
