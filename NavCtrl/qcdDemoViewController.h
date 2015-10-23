//
//  qcdDemoViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"
#import "ChildViewController.h"
#import "AddCompanyViewController.h"
#import "EditCompanyViewController.h"


@class ChildViewController;

@interface qcdDemoViewController : UITableViewController <UIGestureRecognizerDelegate,DataAccessDelegate>


@property (nonatomic, retain) NSMutableArray *companyList;

@property (nonatomic, retain) IBOutlet  ChildViewController * childVC;


-(void) addCompany;

@end
