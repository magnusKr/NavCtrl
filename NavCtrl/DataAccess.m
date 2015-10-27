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
//
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}

- (id)retain {
    return self;
}


- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}



-(void)getCompanyQuoteWithDelegate:(id<DataAccessDelegate>)delegate
{
    
    int k = 0;
    int m = 0;
    self.quoteUrl = @"https://finance.yahoo.com/d/quotes.csv?s=";
    
    while (m < [companyList count]){
        Company* company = [companyList objectAtIndex:m];
        
        if(company.compnayCode != nil)
        {
            if(k==0){
            self.quoteUrl = [self.quoteUrl stringByAppendingString:company.compnayCode];
            }
            
            else{
                self.quoteUrl = [self.quoteUrl stringByAppendingString:@"+"];
                self.quoteUrl = [self.quoteUrl stringByAppendingString:company.compnayCode];
            }
            
            k++;
        }
     m++;
    }
    

    self.quoteUrl = [self.quoteUrl stringByAppendingString:@"&f=a"];
    
    NSURL * url = [NSURL URLWithString:self.quoteUrl];
    
    NSURLSessionDataTask * dataTask = [self.defaultSession dataTaskWithURL:url
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            
    if(error == nil)
    {
        NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        self.companyQuoteArray = [text componentsSeparatedByString:@"\n"];
                                                                
        int i = 0;
        int j = 0;
                                                              
        while (j < [companyList count]){
            Company* company = [companyList objectAtIndex:j];
                                                                    
            if(company.compnayCode != nil)
            {
                company.compnayStockPrice = [self.companyQuoteArray objectAtIndex:i];
                i++;
            }
            j++;
        }
        
        [delegate reload];
        
    }
                                                            
    }];
    [dataTask resume];

}
-(NSString*)getQuoteForCompany : (Company*)company
{
    return company.compnayStockPrice;
}


-(NSMutableArray*)getCompanies
{
    
    return companyList;
}

-(void)deleteCompany :(NSUInteger)companyToDelete
{
    [companyList removeObjectAtIndex: companyToDelete];

}

-(Company*)getCompany :(NSUInteger)companyIndex
{
    
    return [companyList  objectAtIndex:companyIndex];
    
}
-(void)insertCompany :(NSUInteger)insertAtIndex :(Company*)companyToInsert
{
     [companyList insertObject:companyToInsert atIndex:insertAtIndex];

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

-(void)addCompany : (NSString*)companyName :(NSString*)companyCode :(id<DataAccessDelegate>)delegate
{
    
    Company *company = [[Company alloc]initWithName:companyName andcompanyLogo:@"company.png" andcompanycode:companyCode];
    company.listOfCompanyProducts = [[NSMutableArray alloc]init];
    
   
    if(company.compnayCode != nil || ![company.compnayCode  isEqual: @""]){
        
        NSString *urlString =  @"https://finance.yahoo.com/d/quotes.csv?s=";
        urlString = [urlString stringByAppendingString:company.compnayCode];
        urlString = [urlString stringByAppendingString:@"&f=a"];
    
    
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask * dataTask = [self.defaultSession dataTaskWithURL:url
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             
                                                             if(error == nil)
                                                             {
                                                                 NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                 company.compnayStockPrice = text;
                                                                 [delegate reload];
                                                                 
                                                                                                                                


                                                                 
                                                             }
                                                             
                                                         }];
    [dataTask resume];
    
    }
    
    [companyList addObject:company];
    
    [companyName retain];

}
-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company
{
    
    Product *product = [[Product alloc]initWithProductName:productName andproductImage:@"product.png" andProductUrl:productUrl];
    
    [company.listOfCompanyProducts addObject:product];
    
    [productName retain];
    [productUrl retain];

}


-(BOOL)updateCompanyDetails:(Company*)company andIndex:(NSUInteger)index
{
    Company *updateCompany = company;
    
    [companyList removeObjectAtIndex: index];
    
    [companyList insertObject:updateCompany atIndex:index];

    [updateCompany retain];

    return TRUE;

}

-(BOOL)updateProductDetails : (NSString*)productName : (NSString*)productUrl : (NSString*)productImage :(NSUInteger)productIndex : (Company*)company
{
    Company *companyToUpdate = company;
    
    [companyToUpdate.listOfCompanyProducts removeObjectAtIndex: productIndex];
    
     Product *productToUpdate = [[Product alloc]initWithProductName:productName andproductImage:productImage andProductUrl:productUrl];
    
    [company.listOfCompanyProducts insertObject:productToUpdate atIndex:productIndex];
    
    [productName retain];
    [productUrl retain];
    [productImage retain];

    return TRUE;
}

-(void)saveDataToCompanyList
{
    NSData* encodedObject = [NSKeyedArchiver archivedDataWithRootObject:companyList];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"companyList"];
    [defaults synchronize];
}


-(id) init
{
    
    if(self = [super init])
    {
        
        NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
        
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"companyList"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *encodedObject = [defaults objectForKey:@"companyList"];
            self->companyList = [[NSMutableArray alloc]init];
            companyList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        }
        
        else{
            Company *companyOne = [[Company alloc]initWithName:@"Apple Mobile" andcompanyLogo:@"apple.png" andcompanycode:@"AAPL"];
            
            Product *product1 = [[Product alloc]initWithProductName:@"iPad" andproductImage:@"iPad.png" andProductUrl:@"https://www.apple.com/shop/buy-ipad/ipad-air-2"];
            
            Product *product2 = [[Product alloc]initWithProductName:@"iPod Touch" andproductImage:@"ipodtouch.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone6"];
            
            Product *product3 = [[Product alloc]initWithProductName:@"iPhone" andproductImage:@"iphone.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            
            companyOne.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product1,product2,product3, nil];
            
            
            
            Company *companyTwo = [[Company alloc]initWithName:@"Samsung mobile devices" andcompanyLogo: @"samsung.png" andcompanycode:@"GOOG"];
            
            Product *product4 = [[Product alloc]initWithProductName:@"Galaxy S4" andproductImage:@"galaxys4.png" andProductUrl:@"http://www.samsung.com/global/microsite/galaxys4/"];
            
            Product *product5 = [[Product alloc]initWithProductName:@"Galaxy Note" andproductImage:@"galaxys5.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925TZDATMB"];
            
            Product *product6 = [[Product alloc]initWithProductName:@"Galaxy Tab" andproductImage:@"galaxys6.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925RZKAUSC"];
            
            companyTwo.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product4,product5,product6, nil];
            
            
            
            Company *companyThree = [[Company alloc]initWithName:@"Motorola mobile devices" andcompanyLogo:@"motorola.png" andcompanycode:@"MSFT"];
            
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
            
            
            NSData* encodedObject = [NSKeyedArchiver archivedDataWithRootObject:companyList];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:encodedObject forKey:@"companyList"];
            [defaults synchronize];
            
        }
        
        
        
        self.defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration: self.defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
    }
    return self;
}


@end
