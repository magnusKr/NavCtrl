//
//  ProductsViewController.m
//  NavCtrl
//
//  Created by Magnus Kraepelien on 14/10/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ProductsViewController.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    
    webView.navigationDelegate = self;

    NSURL *nsurl=[NSURL URLWithString:self.someUrlToLoad];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [webView loadRequest:nsrequest];
    
    
    
    [self.view addSubview:webView];
    
    [webView release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation: (WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    
}

-(void)webView:(WKWebView *)webView didFailNavigation: (WKNavigation *)navigation withError:(NSError *)error {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {

    [_someUrlToLoad release];
    [super dealloc];
}
@end
