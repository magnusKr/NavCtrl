//
//  CompanyCd+CoreDataProperties.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 09/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyCd.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyCd (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyCdCode;
@property (nullable, nonatomic, retain) NSString *companyCdLogo;
@property (nullable, nonatomic, retain) NSString *companyCdName;
@property (nullable, nonatomic, retain) NSNumber *companyCdRowIndex;
@property (nullable, nonatomic, retain) NSSet<ProductCd *> *products;

@end

@interface CompanyCd (CoreDataGeneratedAccessors)

- (void)addProductsObject:(ProductCd *)value;
- (void)removeProductsObject:(ProductCd *)value;
- (void)addProducts:(NSSet<ProductCd *> *)values;
- (void)removeProducts:(NSSet<ProductCd *> *)values;

@end

NS_ASSUME_NONNULL_END
