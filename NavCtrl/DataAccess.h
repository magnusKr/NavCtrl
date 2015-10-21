//
//  DataAccess.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 19/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Company.h"

@interface DataAccess : NSObject
{
    NSMutableArray* companyList;

}

-(NSMutableArray*)getCompanies;

-(void)deleteCompany :(NSUInteger)companyToDelete;
-(void)insertCompany :(NSUInteger)insertAtIndex :(Company*)companyToInsert;
-(Company*)getCompany :(NSUInteger)companyIndex;
-(NSString*)getCompanyName : (Company*)company;
-(Product*)getCompanyProducts : (Company*)company : (NSUInteger)index;
-(void)deleteCompanyProducts :(NSUInteger)productToDelete : (Company*)company;
-(void)insertCompanyProducts : (Company*)company :(Product*)productToInsert : (NSUInteger)index;
-(void)addCompany : (NSString*)companyName ;
-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company;
-(BOOL)updateCompanyDetails : (NSString*)companyName : (NSString*)logotUrl : (NSUInteger)index;
-(BOOL)updateProductDetails : (NSString*)productName : (NSString*)productUrl : (NSString*)productImage :(NSUInteger)productIndex : (Company*)company;
+ (id)sharedData;


@end
