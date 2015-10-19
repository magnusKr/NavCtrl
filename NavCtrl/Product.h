//
//  Product.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 16/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString* productName;
@property (nonatomic, retain) NSString* productImage;
@property (nonatomic, retain) NSString* productUrl;

-(instancetype)initWithProductName:(NSString*) productName andproductImage :(NSString*) productImage andProductUrl :(NSString*)productUrl;

@end
