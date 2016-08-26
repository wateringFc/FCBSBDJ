//
//  XMGTagsViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/25.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGTagsViewController.h"
#import "XMGTag.h"
#import "XMGTagCell.h"
#import <SVProgressHUD.h>
static NSString *const XMGTagsId = @"tag";
@interface XMGTagsViewController ()

/**
 *  模型数组
 */
@property (strong, nonatomic) NSArray *tagsArr;

@end

@implementation XMGTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTabelView];
    [self loadTagData];
    
}

- (void)setUpTabelView
{
    self.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = FCGlobalColor;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTagCell class]) bundle:nil] forCellReuseIdentifier:XMGTagsId];
}


#pragma mark - 标签请求
- (void)loadTagData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"tag_recommend";
    parames[@"c"] = @"topic";
    parames[@"action"] = @"sub";
    [[AFHTTPSessionManager manager] GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        self.tagsArr = [XMGTag objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGTagCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGTagsId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMGTagCell class]) owner:nil options:nil] lastObject];
    }
    cell.tagModel = self.tagsArr[indexPath.row];
    return cell;
}





@end
