//
//  Company.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithUniqueId:(int)companyId andcompanyname:(NSString*) name andcompanyLogo :(NSString*) logo andcompanycode :(NSString*) companyCode andcompanyrowindex :(int)companyRowIndex
{

        self = [super init];
        if (self) {
            _companyName = name;
            _companyLogo = logo;
            _compnayStockPrice = nil;
            _compnayCode = companyCode;
            _companyId = companyId;
            _companyRowIndex = companyRowIndex;
            [_companyLogo retain];
            [_companyName retain];
            [_compnayCode retain];
        }
        return self;

}

-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo andcompanycode :(NSString*)companyCode andcompanyrowindex:(int)companyRowIndex
{
    
    self = [super init];
    if (self) {
        _companyName = name;
        _companyLogo = logo;
        _compnayStockPrice = nil;
        _compnayCode = companyCode;
        _companyRowIndex = companyRowIndex;
    }
    return self;
    
}

-(void)dealloc{
    [super dealloc];
}


@end
