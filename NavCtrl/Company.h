//
//  Company.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property (nonatomic, retain) Product* companyProducts;
@property (nonatomic, retain) NSMutableArray* listOfCompanyProducts;
@property (nonatomic, retain,readonly) NSString* companyName;
@property (nonatomic, retain,readonly) NSString* companyLogo;

-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo;

@end
