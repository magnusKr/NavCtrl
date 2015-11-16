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

    self.quoteUrl = [self.quoteUrl stringByAppendingString:@"&f=a"];
    
    NSURL * url = [NSURL URLWithString:self.quoteUrl];
    
    AFHTTPRequestOperation* reuquestQuotes = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    //NSURLSessionDataTask * dataTask = [self.defaultSession dataTaskWithURL:url
//                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    [reuquestQuotes setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString * text = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
        self.companyQuoteArray = [text componentsSeparatedByString:@"\n"];
        [text release];
        int i = 0;
        int j = 0;
        while (j < [self.companyList count]){
            Company* company = [self.companyList objectAtIndex:j];
        
            if(company.compnayCode != nil)
            {
                company.compnayStockPrice = [self.companyQuoteArray objectAtIndex:i];
                i++;
            }
                j++;
                
        }
        [delegate reload];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Couldn't connect to stock market!");
}];
    [reuquestQuotes start];

//    if(error == nil)
//    {
//        NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//        self.companyQuoteArray = [text componentsSeparatedByString:@"\n"];
//        [text release];
//        int i = 0;
//        int j = 0;
//                                                              
//        while (j < [self.companyList count]){
//            Company* company = [self.companyList objectAtIndex:j];
//                                                                    
//            if(company.compnayCode != nil)
//            {
//                company.compnayStockPrice = [self.companyQuoteArray objectAtIndex:i];
//                i++;
//            }
//            j++;
//        
//        }
//                                                                
//        [delegate reload];
//    
//    }
//                                                            
//    }];
//    [dataTask resume];

}


-(id) init
{

    if(self = [super init])
    {
        self.quoteUrl = @"https://finance.yahoo.com/d/quotes.csv?s=";
        _companyList = [[NSMutableArray alloc]init];
        _companyCoreDataList = [[NSMutableArray alloc]init];
        
        
        [self initDataModel];
        
        self.defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration: self.defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    }
    return self;
}

- (void)initDataModel {
    
    //my model scheme. Returns a model created by merging all the models found in given bundles
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //psc serve to mediate between the persistent store or stores and the managed object context or contexts
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //Get path to storage
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    BOOL dbExist = [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
    NSLog(@"URl:%@",storeURL);
    
    
    NSError *error = nil;
    
     //To load a model, you provide an URL to the constructor(Persisten store coordinator)
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }

    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    [context setUndoManager:nil];
   
    
    if(!dbExist)
    {
            NSLog(@"FILE NOT EXISTS!!!");

            CompanyCd *commapnyCDOne = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyCd" inManagedObjectContext:context];
            
            [commapnyCDOne setCompanyCdName:@"Apple mobile devices"];
            [commapnyCDOne setCompanyCdLogo:@"apple.png"];
            [commapnyCDOne setCompanyCdCode:@"AAPL"];
            [commapnyCDOne setCompanyCdRowIndex: [NSNumber numberWithInt:1]];
        
        
            ProductCd *productOne = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
        
            [productOne setProductCdName:@"iPad"];
            [productOne setProductCdLogo:@"iPad.png"];
            [productOne setProductCdUrl:@"https://www.apple.com/shop/buy-ipad/ipad-air-2"];
            [productOne setProductCdRowIndex:[NSNumber numberWithInt:1]];
        
        
            [commapnyCDOne addProductsObject:productOne];

        
            ProductCd *productTwo = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productTwo setProductCdName:@"iPod Touch"];
            [productTwo setProductCdLogo:@"ipodtouch.png"];
            [productTwo setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone6"];
            [productTwo setProductCdRowIndex:[NSNumber numberWithInt:2]];
        
            [commapnyCDOne addProductsObject:productTwo];

     

            ProductCd *productThree = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productThree setProductCdName:@"iPhone"];
            [productThree setProductCdLogo:@"iphone.png"];
            [productThree setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productThree setProductCdRowIndex:[NSNumber numberWithInt:3]];
        
            [commapnyCDOne addProductsObject:productThree];


        
            CompanyCd *commapnyCDTwo = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyCd" inManagedObjectContext:context];
        
            [commapnyCDTwo setCompanyCdName:@"Samsung mobile devices"];
            [commapnyCDTwo setCompanyCdLogo:@"samsung.png"];
            [commapnyCDTwo setCompanyCdCode:@"GOOG"];
            [commapnyCDTwo setCompanyCdRowIndex: [NSNumber numberWithInt:2]];
        
        
            ProductCd *productFour = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productFour setProductCdName:@"Galaxy 1"];
            [productFour setProductCdLogo:@"galaxys4.png"];
            [productFour setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productFour setProductCdRowIndex:[NSNumber numberWithInt:1]];
        
            [commapnyCDTwo addProductsObject:productFour];
        
            ProductCd *productFive = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productFive setProductCdName:@"Galaxy 2"];
            [productFive setProductCdLogo:@"galaxys5.png"];
            [productFive setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productFive setProductCdRowIndex:[NSNumber numberWithInt:2]];
        
            [commapnyCDTwo addProductsObject:productFive];
        
        
            ProductCd *productSix = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productSix setProductCdName:@"Galaxy 3"];
            [productSix setProductCdLogo:@"galaxys6.png"];
            [productSix setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productSix setProductCdRowIndex:[NSNumber numberWithInt:3]];
        
            [commapnyCDTwo addProductsObject:productSix];


        
        
            CompanyCd *commapnyCDThree = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyCd" inManagedObjectContext:context];
        
            [commapnyCDThree setCompanyCdName:@"Motorola mobile devices"];
            [commapnyCDThree setCompanyCdLogo:@"motorola.png"];
            [commapnyCDThree setCompanyCdCode:@"MSFT"];
            [commapnyCDThree setCompanyCdRowIndex: [NSNumber numberWithInt:3]];
        
        
        
        
            ProductCd *productSeven = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productSeven setProductCdName:@"Motoroala 1"];
            [productSeven setProductCdLogo:@"motorola1.png"];
            [productSeven setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productSeven setProductCdRowIndex:[NSNumber numberWithInt:1]];
        
            [commapnyCDThree addProductsObject:productSeven];
        
        
            ProductCd *productEight = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productEight setProductCdName:@"Motoroala 2"];
            [productEight setProductCdLogo:@"motorola2.png"];
            [productEight setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productEight setProductCdRowIndex:[NSNumber numberWithInt:2]];
        
            [commapnyCDThree addProductsObject:productEight];
        
        
            ProductCd *productNine = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productNine setProductCdName:@"Motoroala 3"];
            [productNine setProductCdLogo:@"motorola3.jpeg"];
            [productNine setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productNine setProductCdRowIndex:[NSNumber numberWithInt:3]];
        
            [commapnyCDThree addProductsObject:productNine];


        
            CompanyCd *commapnyCDFour = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyCd" inManagedObjectContext:context];
        
            [commapnyCDFour setCompanyCdName:@"HTC mobile devices"];
            [commapnyCDFour setCompanyCdLogo:@"htc.png"];
            [commapnyCDFour setCompanyCdCode:@"-"];
            [commapnyCDFour setCompanyCdRowIndex: [NSNumber numberWithInt:4]];
        
        
            ProductCd *productTen = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productTen setProductCdName:@"Htc 1"];
            [productTen setProductCdLogo:@"htc1.png"];
            [productTen setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productTen setProductCdRowIndex:[NSNumber numberWithInt:1]];
        
            [commapnyCDFour addProductsObject:productTen];
        
            ProductCd *productEleven = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productEleven setProductCdName:@"Htc 2"];
            [productEleven setProductCdLogo:@"htc2.png"];
            [productEleven setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productEleven setProductCdRowIndex:[NSNumber numberWithInt:2]];
        
            [commapnyCDFour addProductsObject:productEleven];
        
        
            ProductCd *productTwelve = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
            [productTwelve setProductCdName:@"Htc 3"];
            [productTwelve setProductCdLogo:@"htc3.png"];
            [productTwelve setProductCdUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
            [productTwelve setProductCdRowIndex:[NSNumber numberWithInt:3]];
        
            [commapnyCDFour addProductsObject:productTwelve];

            [self saveCoreData];

    }


    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"CompanyCd"];
    [request setEntity:e];
    
    NSSortDescriptor *rowIndexSort = [[NSSortDescriptor alloc] initWithKey:@"companyCdRowIndex" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:rowIndexSort, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    

    
    int i;
    for (i=0;i<[result count];i++)
    {
        CompanyCd *c = [result objectAtIndex:i];
      
        int rowIndex = [c.companyCdRowIndex intValue];
        
        Company *company = [[Company alloc] initWithUniqueId:1 andcompanyname:c.companyCdName andcompanyLogo:c.companyCdLogo andcompanycode:c.companyCdCode andcompanyrowindex:rowIndex];
        
        if(company.compnayCode != nil && ![company.compnayCode isEqualToString:@"-"]){
            self.quoteUrl = [self.quoteUrl stringByAppendingString:company.compnayCode];
            self.quoteUrl = [self.quoteUrl stringByAppendingString:@","];
        }
        
        
        company.listOfCompanyProducts = [[NSMutableArray alloc]init];
        for(ProductCd* productCd in c.products) {
             int rowIndex = [productCd.productCdRowIndex intValue];
            Product* product = [[Product alloc]initWithProductNameandIndex:productCd.productCdName andproductImage:productCd.productCdLogo andProductUrl:productCd.productCdUrl andproductrowindex:rowIndex andproductId:1];
            
                        
            [company.listOfCompanyProducts addObject:product];
          
            [product release];
            
        }
        [company.listOfCompanyProducts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"productRowIndex" ascending:YES]]];
        
        [self.companyList addObject:company];
        [self.companyCoreDataList addObject:c];
    
    }
}

-(NSString*) archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"storeses.data"];
}

-(NSUInteger)getNumberOfCompanies
{
    
    return [self.companyList count];
}

-(void)deleteCompany :(NSUInteger)companyToDelete
{
    Company* company = [self.companyList objectAtIndex:companyToDelete];
    
    CompanyCd* companyCd = [self.companyCoreDataList objectAtIndex:companyToDelete];

    [context deleteObject:companyCd];
    
    [self saveCoreData];
    
    
    for (int i = 0;i<[self.companyList count];i++)
    {
        Company* companyTempIndex = [self.companyList objectAtIndex:i];
        CompanyCd* companyCdTempIndex = [self.companyCoreDataList objectAtIndex:i];
        
        if(companyTempIndex.companyRowIndex > company.companyRowIndex)
        {
            companyTempIndex.companyRowIndex--;
            [companyCdTempIndex setValue:[NSNumber numberWithInt:companyTempIndex.companyRowIndex] forKey:@"CompanyCdRowIndex"];
            [self saveCoreData];
        }
    }
    [self.companyCoreDataList removeObjectAtIndex:companyToDelete];
    [self.companyList removeObjectAtIndex: companyToDelete];
    
    
      }

-(Company*)getCompany :(NSUInteger)companyIndex
{
    
    return [self.companyList  objectAtIndex:companyIndex];
    
}


-(void)deleteCompanyProducts :(NSUInteger)IndexToDelete : (Company*)company
{
    
    Product* productToDelete = [company.listOfCompanyProducts objectAtIndex:IndexToDelete];
    CompanyCd* companyCd = [self.companyCoreDataList objectAtIndex:company.companyRowIndex-1];
    
    for (int i = 0;i<[company.listOfCompanyProducts count];i++)
    {
        Product* ProductTempIndex = [company.listOfCompanyProducts objectAtIndex:i];
        ProductCd *productCdTempIndex = [[[companyCd products] allObjects] objectAtIndex:i];
        if(ProductTempIndex.productRowIndex > productToDelete.productRowIndex)
        {
            ProductTempIndex.productRowIndex--;
            [productCdTempIndex setValue:[NSNumber numberWithInt:ProductTempIndex.productRowIndex] forKey:@"ProductCdRowIndex"];
        }
    }
    
    [company.listOfCompanyProducts removeObjectAtIndex: IndexToDelete];
    
    ProductCd *objectToDelete = [[[companyCd products] allObjects] objectAtIndex:IndexToDelete];
    [context deleteObject:objectToDelete];
    
    [self saveCoreData];
    
}



-(void)addCompany : (NSString*)companyName :(NSString*)companyCode :(id<DataAccessDelegate>)delegate
{
    
    NSString *companyLogo = @"company.png";
    int rowIndex = (int) [self.companyList count]+1;
    
    Company *company = [[Company alloc] initWithName:companyName andcompanyLogo:companyLogo andcompanycode:companyCode andcompanyrowindex:rowIndex];
    
    CompanyCd *commpanyCd = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyCd" inManagedObjectContext:context];
    
    [commpanyCd setCompanyCdName:companyName];
    [commpanyCd setCompanyCdLogo:companyLogo];
    [commpanyCd setCompanyCdCode:companyCode];
    [commpanyCd setCompanyCdRowIndex: [NSNumber numberWithInt:rowIndex]];
    
    [self saveCoreData];
    
    if(company.compnayCode != nil || ![company.compnayCode  isEqual: @"-"])
    {
        NSString *urlString =  @"https://finance.yahoo.com/d/quotes.csv?s=";
        urlString = [urlString stringByAppendingString:company.compnayCode];
        urlString = [urlString stringByAppendingString:@"&f=a"];
    
    NSURL * url = [NSURL URLWithString:urlString];
        
     AFHTTPRequestOperation* reuquestQuotes = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
        
        [reuquestQuotes setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
                                                             

        NSString * text = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
                                                                 company.compnayStockPrice = text;
                                                                 [delegate reload];
                                                                 
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Couldn't connect to stock market!");
        }
         
         ];
    [reuquestQuotes start];
    
    }
    company.listOfCompanyProducts = [[NSMutableArray alloc]init];

    [self.companyList addObject:company];
    [self.companyCoreDataList addObject:commpanyCd];
    [company release];
}

-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company
{
    
    Product *product = [[Product alloc]initWithProductName:productName andproductImage:@"product.png" andProductUrl:productUrl];
    
    int rowIndex = (int) [company.listOfCompanyProducts count]+1;
    
    CompanyCd* companyCd = [self.companyCoreDataList objectAtIndex:company.companyRowIndex-1];
    
    ProductCd *productCd = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCd" inManagedObjectContext:context];
    [productCd setProductCdName:productName];
    [productCd setProductCdLogo:@"product.png"];
    [productCd setProductCdUrl:productUrl];
    [productCd setProductCdRowIndex:[NSNumber numberWithInt:rowIndex]];
    
    [companyCd addProductsObject:productCd];
    
    [self saveCoreData];

    [company.listOfCompanyProducts addObject:product];
    [product release];

}


-(BOOL)updateCompanyDetails:(Company*)company andIndex:(NSUInteger)index
{
    Company *updateCompany = company;
    
    NSNumber *rowIndex = [NSNumber numberWithInt:updateCompany.companyRowIndex];
    CompanyCd* commpanyCd = [self.companyCoreDataList objectAtIndex:index];
    
    [commpanyCd setValue:updateCompany.companyName forKey:@"companyCdName"];
    [commpanyCd setValue:updateCompany.companyLogo forKey:@"companyCdLogo"];
    [commpanyCd setValue:updateCompany.compnayCode forKey:@"companyCdCode"];
    [commpanyCd setValue:rowIndex forKey:@"companyCdRowIndex"];

    [self saveCoreData];
    
    [self.companyList replaceObjectAtIndex:index withObject:updateCompany];
    [self.companyCoreDataList replaceObjectAtIndex:index withObject:commpanyCd];

    [updateCompany retain];

    return TRUE;
}

-(BOOL)updateProductDetails : (Product*)productToUpdate :(Company*)company
{
    int rowIndex = (int) productToUpdate.productRowIndex;
    
    CompanyCd* companyCd = [self.companyCoreDataList objectAtIndex:company.companyRowIndex-1];
    
    ProductCd* productCdToUpdate = [[[companyCd products] allObjects] objectAtIndex:rowIndex-1];
    
    [productCdToUpdate setProductCdName:productToUpdate.productName];
    [productCdToUpdate setProductCdLogo:productToUpdate.productImage];
    [productCdToUpdate setProductCdUrl:productToUpdate.productUrl];
    [productCdToUpdate setProductCdRowIndex:[NSNumber numberWithInt:rowIndex]];
    
    [companyCd addProductsObject:productCdToUpdate];
    
    [self saveCoreData];
    
    int productIndex = rowIndex-1;
    
    
    [company.listOfCompanyProducts replaceObjectAtIndex:productIndex withObject:productToUpdate];
    
    [productToUpdate retain];

    return TRUE;
}



-(void)moveCompanyRow :(NSUInteger)fromIndex : (NSUInteger)toIndex
{
    Company* companyToMove = [self.companyList objectAtIndex:fromIndex];
    CompanyCd* companyCdToMove = [self.companyCoreDataList objectAtIndex:fromIndex];
    
    [self.companyList removeObjectAtIndex: fromIndex];
    [self.companyCoreDataList removeObjectAtIndex: fromIndex];
    
    [self.companyList insertObject:companyToMove atIndex:toIndex];
    [self.companyCoreDataList insertObject:companyCdToMove atIndex:toIndex];
    
    for (int i =0 ; i<[self.companyList count]; i++) {
        NSNumber *rowIndex = [NSNumber numberWithInt:i+1];
        
        Company* temp = [self.companyList objectAtIndex:i];
        CompanyCd* companyTempToMove = [self.companyCoreDataList objectAtIndex:i];
        [companyTempToMove setValue:rowIndex forKey:@"companyCdRowIndex"];
        temp.companyRowIndex = i+1;
        [self saveCoreData];
        
    }
    
}


-(void)moveProductRow : (NSUInteger)fromIndex : (NSUInteger)toIndex :(Company*)company
{
    Product* productToMove = [company.listOfCompanyProducts objectAtIndex:fromIndex];
    [productToMove retain];
    [company.listOfCompanyProducts removeObjectAtIndex: fromIndex];
    [company.listOfCompanyProducts insertObject:productToMove atIndex:toIndex];
    
    
    CompanyCd* companyCd = [self.companyCoreDataList objectAtIndex:company.companyRowIndex-1];
    
    for (int i = 0;i<[company.listOfCompanyProducts count];i++)
    {
        Product* temp = [company.listOfCompanyProducts objectAtIndex:i];
        temp.productRowIndex = i+1;
        ProductCd* productCdToUpdate = [[[companyCd products] allObjects] objectAtIndex:i];
        
        [productCdToUpdate setProductCdName:temp.productName];
        [productCdToUpdate setProductCdLogo:temp.productImage];
        [productCdToUpdate setProductCdUrl:temp.productUrl];
        [productCdToUpdate setProductCdRowIndex:[NSNumber numberWithInt:i+1]];
        
        [companyCd addProductsObject:productCdToUpdate];
        
        [self saveCoreData];
        
    }
    
}
-(void)saveCoreData
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }


}

- (void)dealloc {

    [super dealloc];
}

@end
