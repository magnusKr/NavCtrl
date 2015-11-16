//
//  ProductsCViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 13/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "ProductsCVCell.h"
#import "AddProductViewController.h"
#import "EditProductViewController.h"
#import "ProductViewController.h"


@interface ProductsCViewController : UICollectionViewController <UIGestureRecognizerDelegate>
@property (nonatomic, retain) Company* company;

@end
