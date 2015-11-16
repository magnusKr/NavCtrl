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
@interface CompanyCViewController : UICollectionViewController <DataAccessDelegate, UIGestureRecognizerDelegate>


@property(nonatomic,retain) ProductsCViewController* childVC;

-(void)updateQuotes;
@end
