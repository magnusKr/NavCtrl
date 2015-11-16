//
//  CompanyCVCell.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 12/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyCVCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *ImageCell;
@property (retain, nonatomic) IBOutlet UILabel *companyName;
@property (retain, nonatomic) IBOutlet UILabel *companyQuote;

@end
