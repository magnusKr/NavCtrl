//
//  Product.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

-(instancetype)initWithProductName:(NSString*) productName andproductImage :(NSString*) productImage andProductUrl :(NSString*)productUrl
{
    
    self = [super init];
    if (self) {
        _productName = productName;
        _productImage = productImage;
        _productUrl = productUrl;
        
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.productName forKey:@"product_name"];
    [coder encodeObject:self.productImage forKey:@"product_logo"];
    [coder encodeObject:self.productUrl forKey:@"product_url"];

    
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    if (self) {
        self.productName = [coder decodeObjectForKey:@"product_name"];
        self.productImage = [coder decodeObjectForKey:@"product_logo"];
        self.productUrl = [coder decodeObjectForKey:@"product_url"];

        
    }
    return self;
}


@end
