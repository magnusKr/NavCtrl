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
    NSURLSessionDataTask * dataTask = [self.defaultSession dataTaskWithURL:url
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            
    if(error == nil)
    {
        NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        self.companyQuoteArray = [text componentsSeparatedByString:@"\n"];
        [text release];
        int i = 0;
        int j = 0;
                                                              
        while (j < [self.self.companyList count]){
            Company* company = [self.companyList objectAtIndex:j];
                                                                    
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


-(id) init
{

    if(self = [super init])
    {
        self.quoteUrl = @"https://finance.yahoo.com/d/quotes.csv?s=";
        _companyList = [[NSMutableArray alloc]init];
        [self createEditableCopyOfDatabaseIfNeeded];
        
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
        
        
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sqlCompany = "SELECT * FROM companies ORDER BY company_rowindex";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sqlCompany, -1, &statement, NULL) == SQLITE_OK)
        {
             while (sqlite3_step(statement) == SQLITE_ROW)
             {
                 NSString *companyName =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 NSString *companyLogo =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                 NSString *companyCode;
                 int uniqueId = sqlite3_column_int(statement, 3);
                 int companyRowInd = sqlite3_column_int(statement, 4);
                 
                 if(sqlite3_column_text(statement, 2)){
                     companyCode =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                     if(uniqueId != 0){
                         self.quoteUrl = [self.quoteUrl stringByAppendingString:@"+"];
                     }
                     self.quoteUrl = [self.quoteUrl stringByAppendingString:companyCode];
                 }
                 else
                 {
                    companyCode = @"-";
                 }
                 
                  Company *company = [[Company alloc] initWithUniqueId:uniqueId andcompanyname:companyName andcompanyLogo:companyLogo andcompanycode:companyCode andcompanyrowindex:companyRowInd];

                 
                 company.listOfCompanyProducts = [[[NSMutableArray alloc]init] autorelease];
                 
                 sqlite3_close(database);
                 
                 sqlite3_stmt *statementProduct;
                 
                 NSString *sqlProducts = @"SELECT * FROM products WHERE company_id = ";
                 NSString *urlStr = [sqlProducts stringByAppendingFormat:@"%i ORDER BY product_rowindex", uniqueId];

                 const char *sqlProduct = [urlStr UTF8String];
                 
                  if (sqlite3_prepare_v2(database, sqlProduct, -1, &statementProduct, NULL) == SQLITE_OK)
                  {
                      while (sqlite3_step(statementProduct) == SQLITE_ROW)
                      {
                          NSString *productName =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statementProduct, 0)];
                          NSString *productImage =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statementProduct, 1)];
                          NSString *productURL =    [NSString stringWithUTF8String:(char *)sqlite3_column_text(statementProduct, 2)];
                          int productId = sqlite3_column_int(statementProduct, 3);
                          int productRowId = sqlite3_column_int(statementProduct, 5);
                          
                          Product *product = [[Product alloc]initWithProductNameandIndex:productName andproductImage:productImage andProductUrl:productURL andproductrowindex:productRowId andproductId:productId];

                          [company.listOfCompanyProducts addObject:product];
                          [product release];

                      }
                  }
                    [self.companyList addObject:company];
                    [company release];
                }
            }
        sqlite3_close(database);
        
        }
        
        self.defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration: self.defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    }
    return self;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
   
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",writableDBPath);
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"myappdata.sqlite"];
    
    NSLog(@"%@",defaultDBPath);
    if([fileManager fileExistsAtPath:defaultDBPath])
    {
        NSLog(@"File Found..");
    }
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(NSUInteger)getNumberOfCompanies
{
    
    return [self.companyList count];
}

-(void)deleteCompany :(NSUInteger)companyToDelete
{
    Company* company = [self.companyList objectAtIndex:companyToDelete];
    
    for (int i = 0;i<[self.companyList count];i++)
    {
        Company* companyTempIndex = [self.companyList objectAtIndex:i];
        
        if(companyTempIndex.companyRowIndex > company.companyRowIndex)
        {
            companyTempIndex.companyRowIndex--;
        
        }
    }
    
    int index = company.companyId;
    int rowIndex = company.companyRowIndex;
    
    [self.companyList removeObjectAtIndex: companyToDelete];
    
          NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
        NSLog(@"%@",dbPath);
    
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
        
            NSString *deleteCompany = [NSString stringWithFormat:@"DELETE FROM companies WHERE company_id = %i",index];
            NSLog(@"%@",deleteCompany);
        
            const char *sqlRowDelete = [deleteCompany  UTF8String];
            char *error;
            if (sqlite3_exec(database, sqlRowDelete, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
        
            NSLog(@"RowIndex=%i and Comapnylist = %lu",rowIndex,(unsigned long)[self.companyList count]);
        
            for(int i = (rowIndex+1); i<= ([self.companyList count]+1); i++)
            {
                NSString *updateRowIndex = [NSString stringWithFormat:@"UPDATE companies SET company_rowindex = %d WHERE company_rowindex = %i", (i-1), i];
                    
                const char *sqlRowIndexUpdate = [updateRowIndex UTF8String];
                char *error;
            
                if (sqlite3_exec(database, sqlRowIndexUpdate, NULL, NULL, &error)==SQLITE_OK)
                {
                    NSLog(@"Update done .. ");
                }
                else
                {
                    NSLog(@"Error in update.. ");
                }

            }
       
    
        sqlite3_close(database);
    
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
        
            NSString *deleteProductsForCompany = [NSString stringWithFormat:@"DELETE FROM products WHERE company_id = %i",index];
            
            const char *sqlCompanyProductsDelete = [deleteProductsForCompany  UTF8String];
            char *error;
            if (sqlite3_exec(database, sqlCompanyProductsDelete, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
          
        }
        sqlite3_close(database);
    }
}

-(Company*)getCompany :(NSUInteger)companyIndex
{
    return [self.companyList  objectAtIndex:companyIndex];
}


-(void)deleteCompanyProducts :(NSUInteger)IndexToDelete : (Company*)company
{
    
    Product* productToDelete = [company.listOfCompanyProducts objectAtIndex:IndexToDelete];
    
    for (int i = 0;i<[company.listOfCompanyProducts count];i++)
    {
        Product* ProductTempIndex = [company.listOfCompanyProducts objectAtIndex:i];
        
        if(ProductTempIndex.productRowIndex > productToDelete.productRowIndex)
        {
            ProductTempIndex.productRowIndex--;
        }
    }
    int index = productToDelete.productId;
    int rowIndex = productToDelete.productRowIndex;
    
    [company.listOfCompanyProducts removeObjectAtIndex: IndexToDelete];

    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",dbPath);
        
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
            
        NSString *deleteProduct = [NSString stringWithFormat:@"DELETE FROM products WHERE product_id = %i",index];
        NSLog(@"%@",deleteProduct);
            
        const char *sqlRowDelete = [deleteProduct  UTF8String];
        char *error;
        if (sqlite3_exec(database, sqlRowDelete, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Update done .. ");
        }
        else
        {
            NSLog(@"Error in update.. ");
        }
            
        NSLog(@"RowIndex=%i and Comapnylist = %lu",rowIndex,(unsigned long)[self.companyList count]);
            
        for(int i = (rowIndex+1); i<= ([company.listOfCompanyProducts count]+1); i++)
        {
            NSString *updateRowIndex = [NSString stringWithFormat:@"UPDATE products SET product_rowindex = %d WHERE product_rowindex = %i", (i-1), i];
                
            const char *sqlRowIndexUpdate = [updateRowIndex UTF8String];
            char *error;
                
            if (sqlite3_exec(database, sqlRowIndexUpdate, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
                
        }
       
        sqlite3_close(database);
        
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
            
            NSString *deleteProductsForCompany = [NSString stringWithFormat:@"DELETE FROM products WHERE company_id = %i",index];
            
            const char *sqlCompanyProductsDelete = [deleteProductsForCompany  UTF8String];
            char *error;
            
            if (sqlite3_exec(database, sqlCompanyProductsDelete, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
        }
        sqlite3_close(database);
    }
}



-(void)addCompany : (NSString*)companyName :(NSString*)companyCode :(id<DataAccessDelegate>)delegate
{
    
    NSString *companyLogo = @"company.png";
    int rowIndex = (int) [self.companyList count]+1;
    
    Company *company = [[Company alloc] initWithName:companyName andcompanyLogo:companyLogo andcompanycode:companyCode andcompanyrowindex:rowIndex];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",dbPath);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *insertNewCompany = [NSString stringWithFormat:@"INSERT INTO companies (company_name, company_logo, company_code,company_rowindex)VALUES ('%@','%@','%@','%i')",companyName,companyLogo,companyCode,rowIndex];
            
        const char *sqlRowInd = [insertNewCompany  UTF8String];
        char *error;
        
        if (sqlite3_exec(database, sqlRowInd, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Update done .. ");
        }
        else
        {
            NSLog(@"Error in update.. ");
        }
    }
    sqlite3_close(database);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *getCompanyId = [NSString stringWithFormat:@"SELECT MAX(company_id) from companies"];
        sqlite3_stmt *statement;
       
        const char *sqlGetId = [getCompanyId  UTF8String];
        NSLog(@"%@", company.companyName);
        
        if (sqlite3_prepare_v2(database, sqlGetId, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *companyID =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                company.companyId = [companyID intValue];
            }
        }
        
    }
    
    sqlite3_close(database);
    
    if(company.compnayCode != nil || ![company.compnayCode  isEqual: @"-"])
    {
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
    company.listOfCompanyProducts = [[NSMutableArray alloc]init];

    [self.companyList addObject:company];
    [company release];
}

-(void)addProductToCompany : (NSString*)productName : (NSString*)productUrl : (Company*)company
{
    
    Product *product = [[Product alloc]initWithProductName:productName andproductImage:@"product.png" andProductUrl:productUrl];
    
    int companyId = company.companyId;
    
    int rowIndex = (int) [company.listOfCompanyProducts count]+1;

    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",dbPath);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *insertNewProduct = [NSString stringWithFormat:@"INSERT INTO products (product_name, product_image, product_url,company_id,product_rowindex)VALUES ('%@','%@','%@','%i','%i')",product.productName,product.productImage,product.productUrl,companyId,rowIndex];

        const char *sqlInsertProduct = [insertNewProduct  UTF8String];
        char *error;
        
        if (sqlite3_exec(database, sqlInsertProduct, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Update done .. ");
        }
        else
        {
            NSLog(@"Error in update.. ");
        }
    }
    sqlite3_close(database);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *getproductId = [NSString stringWithFormat:@"SELECT MAX(product_id) from products"];
        sqlite3_stmt *statement;
        
        const char *sqlGetId = [getproductId  UTF8String];
  
        if (sqlite3_prepare_v2(database, sqlGetId, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *productID =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                product.productId = [productID intValue];
            }
        }
        
    }
    
    sqlite3_close(database);

    [company.listOfCompanyProducts addObject:product];
    [product release];
    
//    [productName retain];
//    [productUrl retain];
}


-(BOOL)updateCompanyDetails:(Company*)company andIndex:(NSUInteger)index
{
    Company *updateCompany = company;
    
    // avoid repetative codes - put it into a method to return the path
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
 
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
            NSString *updateCompanyDetails = [NSString stringWithFormat:@"UPDATE companies SET company_name = '%@', company_logo = '%@', company_code = '%@' WHERE company_id = %i", updateCompany.companyName, updateCompany.companyLogo, updateCompany.compnayCode, updateCompany.companyId];
            
            const char *sqlUpdateCompanyDetail = [updateCompanyDetails  UTF8String];
            char *error;
        
            if (sqlite3_exec(database, sqlUpdateCompanyDetail, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
    }
    sqlite3_close(database);
    
    [self.companyList removeObjectAtIndex: index];
    
    [self.companyList insertObject:updateCompany atIndex:index];

    [updateCompany retain];

    return TRUE;
}

-(BOOL)updateProductDetails : (Product*)productToUpdate
{
    
    Product *updateProduct = productToUpdate;
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *updateproductDetails = [NSString stringWithFormat:@"UPDATE products SET product_name = '%@', product_image = '%@', product_url = '%@'  WHERE product_id = %i", updateProduct.productName, updateProduct.productImage, updateProduct.productUrl, updateProduct.productId];
        
        const char *sqlUpdateproductDetail = [updateproductDetails  UTF8String];
        char *error;
        if (sqlite3_exec(database, sqlUpdateproductDetail, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Update done .. ");
        }
        else
        {
            NSLog(@"Error in update.. ");
        }
    }
    sqlite3_close(database);
    
    // lines below are not required as parameter product is reference to the same product in the list
  //  [updateCompany.listOfCompanyProducts removeObjectAtIndex: productToUpdate.productRowIndex-1];
   // [company.listOfCompanyProducts insertObject:productToUpdate atIndex:productToUpdate.productRowIndex-1];
    
    //[productToUpdate retain];

    return TRUE;
}



-(void)moveCompanyRow :(NSUInteger)fromIndex : (NSUInteger)toIndex
{
    Company* companyToMove = [self.companyList objectAtIndex:fromIndex];
    
  //  Company* company = [self.companyList objectAtIndex:fromIndex];
    
    for (int i = 0;i<[self.companyList count];i++)
    {
        Company* companyTempIndex = [self.companyList objectAtIndex:i];
        
        if(companyTempIndex.companyRowIndex > companyToMove.companyRowIndex)
        {
            companyTempIndex.companyRowIndex--;
            
        }
    }
    
   // int index = company.companyId;
   // int rowIndex = company.companyRowIndex;
    
    [self.companyList removeObjectAtIndex: fromIndex];
    [self.companyList insertObject:companyToMove atIndex:toIndex];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",dbPath);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        for(int j = 0;j<[self.companyList count];j++)
        {
            Company *companyToUpdate = [self.companyList objectAtIndex:j];
            
            
            int index = companyToUpdate.companyId;
            
            NSString *queryUpdateRowIndex = [NSString stringWithFormat:@"UPDATE companies SET company_rowindex = %d WHERE company_id = %i", j+1, index];
            
            const char *sqlRowInd = [queryUpdateRowIndex  UTF8String];
            char *error;
            if (sqlite3_exec(database, sqlRowInd, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
        }
        sqlite3_close(database);
    }
}


-(void)moveProductRow : (NSUInteger)fromIndex : (NSUInteger)toIndex :(Company*)company
{
    Product* productToDelete = [company.listOfCompanyProducts objectAtIndex:fromIndex];
    
    for (int i = 0;i<[company.listOfCompanyProducts count];i++)
    {
        Product* ProductTempIndex = [company.listOfCompanyProducts objectAtIndex:i];
        
        if(ProductTempIndex.productRowIndex > productToDelete.productRowIndex)
        {
            ProductTempIndex.productRowIndex--;
        }
    }
    int index = productToDelete.productId;
   // int rowIndex = productToDelete.productRowIndex;
    
    [company.listOfCompanyProducts removeObjectAtIndex: fromIndex];
    
    productToDelete.productRowIndex = index+1.0;
    [company.listOfCompanyProducts insertObject:productToDelete atIndex:toIndex];
    
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"myappdata.sqlite"];
    NSLog(@"%@",dbPath);
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        for(int j = 0;j<[company.listOfCompanyProducts count];j++)
        {
            Product *productToUpdate = [company.listOfCompanyProducts objectAtIndex:j];
            
            int index = productToUpdate.productId;
            
            NSString *queryUpdateRowIndex = [NSString stringWithFormat:@"UPDATE products SET product_rowindex = %d WHERE product_id = %i", j+1, index];
            
            const char *sqlRowInd = [queryUpdateRowIndex  UTF8String];
            char *error;
            if (sqlite3_exec(database, sqlRowInd, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Update done .. ");
            }
            else
            {
                NSLog(@"Error in update.. ");
            }
        }
        sqlite3_close(database);
    }





}



- (void)dealloc {
    sqlite3_close(database);
    [super dealloc];
}

@end
