//
//  ResultViewController.m
//  RPQRcode
//
//  Created by mac on 2018/3/26.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ResultViewController.h"

#import <WebKit/WebKit.h>
@implementation ResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这个界面我只是简单的处理一下，可以自己定制,实际应用中扫码跳转不可能就这两种逻辑
    if ([_contentString hasPrefix:@"http"]) {
        
        WKWebView *showView = [[WKWebView alloc] initWithFrame:RPScreen];
        NSURLRequest *codeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_contentString]];
        [showView loadRequest:codeRequest];
        [self.view addSubview:showView];
        
    } else {
        
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 200, 50)];
        showLabel.center = self.view.center;
        showLabel.font = [UIFont boldSystemFontOfSize:16];
        showLabel.text = [NSString stringWithFormat:@"扫描结果是---%@",_contentString];
        showLabel.numberOfLines = 0;
        [self.view addSubview:showLabel];
    }
    
    
}

@end

