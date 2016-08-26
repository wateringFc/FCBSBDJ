//
//  FCWebViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCWebViewController.h"
#import <NJKWebViewProgress.h>

@interface FCWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
/**
 *  网页加载模拟进度条
 */
@property (strong, nonatomic) NJKWebViewProgress *progress;
@property (weak, nonatomic) IBOutlet UIProgressView *prgsView;

@end

@implementation FCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    // 把webView的代理设置给 进度条类
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress) {
        weakSelf.prgsView.progress = progress;
        weakSelf.prgsView.hidden = (progress == 1.0);
    };
    // 把代理再转给控制器（在控制器里面的webView的代理才能执行）
    self.progress.webViewProxyDelegate = self;
    
    // 读取网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}
// 刷新
- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

// 返回
- (IBAction)goBack:(id)sender
{
    [self.webView goBack];
}

// 前进
- (IBAction)goForward:(id)sender
{
    [self.webView goForward];
}



#pragma mark- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.goBack.enabled = webView.canGoBack;
    self.forward.enabled = webView.canGoForward;
}


@end
