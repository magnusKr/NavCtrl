//
//  qcdDemoViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"
#import "CompanyProductsViewController.h"
#import "AddCompanyViewController.h"
#import "EditCompanyViewController.h"


@class CompanyProductsViewController;

@interface CompanyViewController : UITableViewController <UIGestureRecognizerDelegate,DataAccessDelegate>

@property (nonatomic, retain) IBOutlet  CompanyProductsViewController * childVC;

-(void) addCompany;

@end
