//
//  ChildViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"
#import "CompanyViewController.h"
#import "AddProductViewController.h"
#import "EditProductViewController.h"



@interface CompanyProductsViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, retain) Company* company;

-(void)addProduct;





@end
