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

@property int companyId;
@property (nonatomic, retain) NSString* companyName;
@property (nonatomic, retain) NSString* companyLogo;
@property (nonatomic, retain) NSString* compnayStockPrice;
@property (nonatomic, retain) NSString* compnayCode;
@property int companyRowIndex;


-(instancetype)initWithUniqueId:(int)companyId andcompanyname:(NSString*) name andcompanyLogo :(NSString*) logo andcompanycode :(NSString*) companyCode andcompanyrowindex :(int)companyRowIndex;
-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo andcompanycode :(NSString*)companyCode andcompanyrowindex:(int)companyRowIndex;

@end
