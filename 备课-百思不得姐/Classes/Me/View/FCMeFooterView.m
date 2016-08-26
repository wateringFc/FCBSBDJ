//
//  FCMeFooterView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCMeFooterView.h"
#import "FCSquare.h"
#import "FCSquareButton.h"
#import "FCWebViewController.h"
@interface FCMeFooterView()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation FCMeFooterView

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = FCGlobalColor;
        [self loadData];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 设置背景图片
    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
}

#pragma mark - 数据请求
- (void)loadData
{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"square";
    parames[@"c"] = @"topic";
    [self.manager GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *sqaures = [FCSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        // 根据服务器返回数据创建方块
        [self createSqaures:sqaures];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
    }];
    
}


- (void)createSqaures:(NSArray *)sqaures
{
    // 一行4个
    int maxCols = 4;
    // 宽度和高度
    CGFloat buttonW = SCREENWIDTH / maxCols;
    CGFloat buttonH = buttonW;
    for (int i = 0; i < sqaures.count; i++) {
        FCSquareButton *button = [FCSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.squareModel = sqaures[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        button.xmg_x = col * buttonW;
        button.xmg_y = row * buttonH;
        button.xmg_width = buttonW;
        button.xmg_height = buttonH;
        
        // 计算footer高度(方法一 最简单)
//        self.xmg_height = CGRectGetMaxY(button.frame);
    }
    
    // 计算footer高度(方法二 要判断) 根据返回个数（已知一行返回4个），如果能整除返回整除后的行数乘按钮高度，不能整除则加1
//    NSUInteger rows = sqaures.count / maxCols;
//    if (sqaures.count % maxCols) { // 不能整除则加1
//        rows ++;
//    }
    
    // 总页数 = (总个数 + 每页的最大数 - 1) / 每页最大数 (方法三 用公式)
    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;
    self.xmg_height = rows * buttonH;
    
    // 重绘之后才能使用自己设置的背景图片
    [self setNeedsDisplay];
}


- (void)buttonClick:(FCSquareButton *)button
{
    // 只处理 http
    if (![button.squareModel.url hasPrefix:@"http"]) {
        return;
    }
    FCWebViewController *web = [[FCWebViewController alloc] init];
    web.url = button.squareModel.url;
    web.title = button.squareModel.name;
    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
    
}



@end
