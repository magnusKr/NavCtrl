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
@property int productRowIndex;
@property int productId;


-(instancetype)initWithProductName:(NSString*) productName andproductImage :(NSString*) productImage andProductUrl :(NSString*)productUrl;
-(instancetype)initWithProductNameandIndex:(NSString*)productName andproductImage:(NSString*)productImage andProductUrl:(NSString*)productURL andproductrowindex:(int)productRowId andproductId :(int)productId;
@end
