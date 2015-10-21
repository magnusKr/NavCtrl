//
//  EditProductViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 21/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qcdDemoViewController.h"

@interface EditProductViewController : UIViewController
@property NSUInteger productIndex;
@property (retain, nonatomic) Company* company;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UITextField *productName;
@property (retain, nonatomic) IBOutlet UITextField *productUrl;
@property (retain, nonatomic) IBOutlet UILabel *productImageUrl;
- (IBAction)updateProductButton:(id)sender;



@end
