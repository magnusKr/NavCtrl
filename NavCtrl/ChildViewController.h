//
//  ChildViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsViewController.h"
#import "qcdDemoViewController.h"
#import "AddProductViewController.h"
#import "EditProductViewController.h"



@interface ChildViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, retain) Company* company;

-(void)addProduct;





@end
