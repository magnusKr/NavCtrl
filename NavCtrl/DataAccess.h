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

@protocol DataAccessDelegate <NSObject>

-(void)reload;

@end

@interface DataAccess : NSObject <NSURLSessionDelegate>
{
    NSMutableArray* companyList;

}
@property (nonatomic,retain) NSArray* companyQuoteArray;
@property (nonatomic,retain) NSString* quoteUrl;

-(NSMutableArray*)getCompanies;
-(void)getCompanyQuoteWithDelegate:(id<DataAccessDelegate>)delegate;
-(void)deleteCompany :(NSUInteger)companyToDelete;
-(void)insertCompany :(NSUInteger)insertAtIndex :(Company*)companyToInsert;
-(Company*)getCompany :(NSUInteger)companyIndex;
-(NSString*)getCompanyName : (Company*)company;
-(Product*)getCompanyProducts : (Company*)company : (NSUInteger)index;
-(void)deleteCompanyProducts :(NSUInteger)productToDelete : (Company*)company;
-(void)insertCompanyProducts : (Company*)company :(Product*)productToInsert : (NSUInteger)index;
-(void)addCompany : (NSString*)companyName :(NSString*)companyCode ;
-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company;
-(BOOL)updateCompanyDetails:(Company*)company andIndex:(NSUInteger)index;



-(BOOL)updateProductDetails : (NSString*)productName : (NSString*)productUrl : (NSString*)productImage :(NSUInteger)productIndex : (Company*)company;
-(NSString*)getQuoteForCompany : (Company*)company;

+ (id)sharedData;


@end
