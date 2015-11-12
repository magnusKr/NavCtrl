//
//  ProductCd+CoreDataProperties.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 09/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductCd.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCd (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productCdLogo;
@property (nullable, nonatomic, retain) NSString *productCdName;
@property (nullable, nonatomic, retain) NSNumber *productCdRowIndex;
@property (nullable, nonatomic, retain) NSString *productCdUrl;
@property (nullable, nonatomic, retain) CompanyCd *relationship;

@end

NS_ASSUME_NONNULL_END
