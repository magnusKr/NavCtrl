//
//  Company.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString*) name andcompanyLogo :(NSString*) logo
{

        self = [super init];
        if (self) {
            _companyName = name;
            _companyLogo = logo;
      
        }
        return self;




}

@end
