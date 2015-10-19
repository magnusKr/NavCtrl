//
//  DataAccess.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 19/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DataAccess.h"


static DataAccess *sharedDataAccess = nil;

@implementation DataAccess

+(id)sharedData
{
    @synchronized(self) {
        if(sharedDataAccess == nil)
         sharedDataAccess = [[super allocWithZone:NULL] init];
    }

    return sharedDataAccess;

}

+(id)allocWithZone:(NSZone *)zone
{
    return [[self sharedData] retain];

}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

//- (unsigned)retainCount {
//    return UINT_MAX; //denotes an object that cannot be released
//}

- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}


-(id) init
{

    if(self = [super init])
    {
        Company *companyOne = [[Company alloc]initWithName:@"Apple mobile devices" andcompanyLogo:@"apple.png"];
        Product *product1 = [[Product alloc]initWithProductName:@"iPad" andproductImage:@"iPad.png" andProductUrl:@"https://www.apple.com/shop/buy-ipad/ipad-air-2"];
        
        
        Product *product2 = [[Product alloc]initWithProductName:@"iPod Touch" andproductImage:@"ipodtouch.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone6"];
        
        Product *product3 = [[Product alloc]initWithProductName:@"iPhone" andproductImage:@"iphone.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
        
        companyOne.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product1,product2,product3, nil];
        
        Company *companyTwo = [[Company alloc]initWithName:@"Samsung mobile devices" andcompanyLogo: @"samsung.png"];
        
        Product *product4 = [[Product alloc]initWithProductName:@"Galaxy S4" andproductImage:@"galaxys4.png" andProductUrl:@"http://www.samsung.com/global/microsite/galaxys4/"];
        
        
        Product *product5 = [[Product alloc]initWithProductName:@"Galaxy Note" andproductImage:@"galaxys5.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925TZDATMB"];
        
        Product *product6 = [[Product alloc]initWithProductName:@"Galaxy Tab" andproductImage:@"galaxys6.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925RZKAUSC"];
        
        companyTwo.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product4,product5,product6, nil];
        
        
        Company *companyThree = [[Company alloc]initWithName:@"Motorola mobile devices" andcompanyLogo:@"motorola.png"];
        
        
        
        
        Product *product7 = [[Product alloc]initWithProductName:@"X Pure Edition" andproductImage:@"motorola1.png" andProductUrl:@"https://www.motorola.com/us/products/moto-g"];
        
        
        Product *product8 = [[Product alloc]initWithProductName:@"Moto E" andproductImage:@"motorola2.png" andProductUrl:@"http://www.motorola.com/us/products/moto-x-pure-edition"];
        
        Product *product9 = [[Product alloc]initWithProductName:@"Moto X" andproductImage:@"motorola3.jpeg" andProductUrl:@"https://www.motorola.com/us/smartphones/moto-e-2nd-gen/moto-e-2nd-gen.html"];
        
        companyThree.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product7,product8,product9, nil];
        
        
        
        Company *companyFour = [[Company alloc]initWithName:@"HTC mobile devices" andcompanyLogo:@"htc.png"];
        
        Product *product10 = [[Product alloc]initWithProductName:@"Desire 123" andproductImage:@"htc1.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-desire-626/"];
        
        
        Product *product11 = [[Product alloc]initWithProductName:@"Desire 510" andproductImage:@"htc2.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-one-mini/"];
        
        Product *product12 = [[Product alloc]initWithProductName:@"Desire 237" andproductImage:@"htc3.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-one-max/"];
        
        companyFour.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product10,product11,product12, nil];
        
        self->companyList = [[NSMutableArray alloc]initWithObjects:companyOne,companyTwo,companyThree,companyFour, nil];
    
    
    }
    return self;
}

-(void)dealloc
{
    [companyList release];
    [super dealloc];

}

-(NSMutableArray*)getCompanies
{
    
    return self->companyList;
}

-(void)deleteCompany :(NSUInteger)companyToDelete
{
    [self->companyList removeObjectAtIndex: companyToDelete];

}

-(Company*)getCompany :(NSUInteger)companyIndex
{
    return [self->companyList  objectAtIndex:companyIndex];
    
}
-(void)insertCompany :(NSUInteger)insertAtIndex :(Company*)companyToInsert
{
     [self->companyList insertObject:companyToInsert atIndex:insertAtIndex];

}

-(NSString*)getCompanyName : (Company*)company
{
    return company.companyName;

}

-(Product*)getCompanyProducts : (Company*)company : (NSUInteger)index
{
    return [company.listOfCompanyProducts objectAtIndex:index];

}

-(void)deleteCompanyProducts :(NSUInteger)productToDelete : (Company*)company
{
    [company.listOfCompanyProducts removeObjectAtIndex: productToDelete];
}

-(void)insertCompanyProducts : (Company*)company :(Product*)productToInsert : (NSUInteger)index
{
    [company.listOfCompanyProducts insertObject:productToInsert atIndex:index];
}

@end
