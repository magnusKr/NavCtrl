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

-(instancetype)initWithProductNameandIndex:(NSString*)productName andproductImage:(NSString*)productImage andProductUrl:(NSString*)productURL andproductrowindex:(int)productRowId andproductId :(int)productId
{
    
    self = [super init];
    if (self) {
        _productName = productName;
        _productImage = productImage;
        _productUrl = productURL;
        _productRowIndex = productRowId;
        _productId = productId;
        
        
    }
    return self;
    
}
@end
