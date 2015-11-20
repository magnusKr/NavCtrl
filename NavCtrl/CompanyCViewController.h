//
//  CompanyCViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 12/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"
#import "AddCompanyViewController.h"
#import "EditCompanyViewController.h"
#import "CompanyCVCell.h"
#import "ProductsCViewController.h"

@class ProductsCViewController;
@class AddCompanyViewController;
@class EditCompanyViewController;

@interface CompanyCViewController : UICollectionViewController <DataAccessDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,retain) ProductsCViewController* productsViewController;
@property(nonatomic,retain) AddCompanyViewController* addCompanyViewController;
@property(nonatomic,retain) EditCompanyViewController* editCompanyViewController;



@end
