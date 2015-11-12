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
#import "CompanyCd.h"
#import "ProductCd.h"
#import <CoreData/CoreData.h>


@protocol DataAccessDelegate <NSObject>

-(void)reload;

@end

@interface DataAccess : NSObject <NSURLSessionDelegate>
{
    
    NSManagedObjectModel *model;
    NSManagedObjectContext *context;
}
@property (nonatomic,retain) NSMutableArray* companyList;
@property (nonatomic,retain) NSMutableArray* companyCoreDataList;

@property (nonatomic,retain) NSArray* companyQuoteArray;
@property (nonatomic,retain) NSString* quoteUrl;
@property (nonatomic,retain) NSURLSessionConfiguration* defaultConfigObject;
@property (nonatomic,retain) NSURLSession *defaultSession;



-(NSUInteger)getNumberOfCompanies;
-(void)getCompanyQuoteWithDelegate:(id<DataAccessDelegate>)delegate;
-(void)deleteCompany :(NSUInteger)companyToDelete;
-(void)moveCompanyRow :(NSUInteger)fromIndex : (NSUInteger)toIndex;
-(void)moveProductRow : (NSUInteger)fromIndex : (NSUInteger)toIndex :(Company*)company;
-(Company*)getCompany :(NSUInteger)companyIndex;
-(void)deleteCompanyProducts :(NSUInteger)IndexToDelete : (Company*)company;
-(void)initDataModel;
-(void)addCompany : (NSString*)companyName :(NSString*)companyCode :(id<DataAccessDelegate>)delegate;
-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company;
-(BOOL)updateCompanyDetails:(Company*)company andIndex:(NSUInteger)index;
-(BOOL)updateProductDetails : (Product*)productToUpdate :(Company*)company;
-(NSString*) archivePath;
-(void)saveCoreData;


+ (id)sharedData;


@end
