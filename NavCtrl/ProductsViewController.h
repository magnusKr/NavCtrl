//
//  ProductsViewController.h
//  NavCtrl
//
//  Created by Magnus Kraepelien on 14/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ProductsViewController : UIViewController <UIWebViewDelegate,WKNavigationDelegate>


@property (nonatomic, retain) NSString *someUrlToLoad;

//Property for WKWebView
//@property(retain, nonatomic) WKWebView *webView;

@end
