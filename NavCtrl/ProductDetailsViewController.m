//
//  ProductsViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 14/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ProductDetailsViewController.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    
    self.detailProductView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
    
    
    self.detailProductView.navigationDelegate = self;

    NSURL *nsurl=[NSURL URLWithString:self.productUrlToLoad];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [self.detailProductView loadRequest:nsrequest];
    
    [self.view addSubview:self.detailProductView];
    
    [webViewConfiguration release];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation: (WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    
}

-(void)webView:(WKWebView *)webView didFailNavigation: (WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)dealloc {

    [_productUrlToLoad release];
    [_detailProductView release];
    [super dealloc];
}
@end
