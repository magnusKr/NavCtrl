//
//  ProductsCVCell.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 13/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ProductsCVCell.h"

@implementation ProductsCVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_productImage release];
    [_productName release];
    [super dealloc];
}
@end
