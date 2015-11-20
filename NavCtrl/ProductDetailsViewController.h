//
//  ProductsViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 14/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ProductDetailsViewController : UIViewController <UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic, retain) NSString *productUrlToLoad;
@property(retain, nonatomic) WKWebView *detailProductView;

@end
