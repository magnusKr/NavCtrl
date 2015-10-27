//
//  Company.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo andcompanycode :(NSString*) companyCode
{

        self = [super init];
        if (self) {
            _companyName = name;
            _companyLogo = logo;
            _compnayStockPrice = nil;
            _compnayCode = companyCode;
        }
        return self;

}

-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo
{
    
    self = [super init];
    if (self) {
        _companyName = name;
        _companyLogo = logo;
        _compnayStockPrice = nil;
        _compnayCode = nil;
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.companyName forKey:@"company_name"];
    [coder encodeObject:self.companyLogo forKey:@"company_logo"];
    [coder encodeObject:self.compnayStockPrice forKey:@"company_stockprice"];
    [coder encodeObject:self.compnayCode forKey:@"company_code"];
    [coder encodeObject:self.listOfCompanyProducts forKey:@"company_products"];
    
}

- (id)initWithCoder:(NSCoder *)coder {

    self = [super init];
    if (self) {
        self.companyName = [coder decodeObjectForKey:@"company_name"];
        self.companyLogo = [coder decodeObjectForKey:@"company_logo"];
        self.compnayStockPrice = [coder decodeObjectForKey:@"company_stockprice"];
        self.compnayCode = [coder decodeObjectForKey:@"company_code"];
        self.listOfCompanyProducts = [coder decodeObjectForKey:@"company_products"];
    
    }
    return self;
}

@end
