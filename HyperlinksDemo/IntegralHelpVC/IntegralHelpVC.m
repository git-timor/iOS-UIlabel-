//
//  IntegralHelp.m
//  RAJ
//
//  Created by ZhouQi on 15/7/24.
//  Copyright (c) 2016年 周周旗. All rights reserved.
//
#import "ZQShareMethod.h"
#import "IntegralHelpVC.h"

@interface IntegralHelpVC ()<UIWebViewDelegate> {
    BOOL loadSucceeded;
    UIWebView *mWebView;
    UIButton *btn_Close;
}
@property (strong,nonatomic)NSString *currentTitle;
@end

@implementation IntegralHelpVC

- (void)viewDidLoad {
    self.customNavigationBar = YES;
    [super viewDidLoad];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [self hideHUD];
}

- (void)initData{
    self.view.backgroundColor = MCOLOR_BACKGROUND_F2F2F2;
    self.titleView.text = self.titleText;
    [self setBtnClose];
}

- (void)initSubViews {
    [self initData];
    
    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsurl = [NSURL URLWithString:_url] ;
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30.f];
    mWebView.delegate = self;
    [mWebView loadRequest:request];
    [self.view addSubview:mWebView];
    [self showHUD];
    
}

- (void)setBtnClose{
    btn_Close = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, self.navigationView.height)];
    btn_Close.alpha = 0;
    [UIView animateWithDuration:0.8f animations:^{
        btn_Close.alpha = 1;
        [btn_Close setFrame:CGRectMake(40, 0, 70, self.navigationView.height)];
    } completion:^(BOOL finished) {
    }];
    [btn_Close addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [btn_Close setTitle:@"关闭" forState:UIControlStateNormal];
    [btn_Close setTitleColor:[UIColor whiteColor]   forState:(UIControlStateNormal)];
    [btn_Close setTitleColor:[UIColor whiteColor]   forState:(UIControlStateSelected)];
    [btn_Close setTitleColor:[UIColor whiteColor]   forState:(UIControlStateHighlighted)];
    [btn_Close.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    btn_Close.imageEdgeInsets = UIEdgeInsetsMake(0, - (self.navigationView.height/2+5), 0, 0);
    [self.navigationView addSubview:btn_Close];
    btn_Close.hidden = YES;
}

- (void)clickClose{
    [UIView animateWithDuration:0.8f animations:^{
        btn_Close.alpha = 0;
        [btn_Close setFrame:CGRectMake(0, 0, 70, self.navigationView.height)];
    } completion:^(BOOL finished) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ActionForBackButton:(UIButton *)button{
    if ([mWebView canGoBack]) {
        [mWebView goBack];
        btn_Close.hidden = NO;
        [self.titleView setFrame:CGRectMake(105, 0, self.navigationView.width-140, self.navigationView.height)];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma - UIWebView

//当网页视图已经开始加载一个请求后，得到通知。
- (void)webViewDidStartLoad:(UIWebView*)webView {
    loadSucceeded = YES;
}

//当网页视图结束加载一个请求之后，得到通知。
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    if (webView.isLoading) {
        return;
    }
    loadSucceeded = YES;
    [self hideHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    //获取网页名称
    self.currentTitle = [mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleView.text = self.currentTitle ? self.currentTitle : self.titleText;
    NSLog(@"+++++++++++++网页加载成功+++++++++++++");
}

//当在请求加载中发生错误时
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    loadSucceeded = YES;
    [self hideHUD];
    NSLog(@"+++++++++++++网页加载出错+++++++++++++");
}

@end
