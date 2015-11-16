//
//  CompanyCVCell.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 12/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CompanyCVCell.h"

@implementation CompanyCVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_ImageCell release];
    [_companyName release];
    [_companyQuote release];
    [super dealloc];
}
@end
