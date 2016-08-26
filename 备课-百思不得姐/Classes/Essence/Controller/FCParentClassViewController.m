//
//  FCParentClassViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCParentClassViewController.h"
#import "FCTopicModel.h"
#import "XMGTopicCell.h"
#import "FCCommentViewController.h"
static NSString *const FCtopicsId = @"topic";

@interface FCParentClassViewController ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topicsArr;
/** 加载所需参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 存储上一次请求参数(用于处理刷新加载同时进行的情况处理最后一个操作) */
@property (nonatomic, strong) NSMutableDictionary *parame;
/** 上次选中个索引（用于再次点击tabBaritme刷新本页） */
@property (nonatomic, assign) NSInteger lastSelectIndex;

@end

@implementation FCParentClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpRefresh];
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)topicsArr
{
    if (!_topicsArr) {
        _topicsArr = [NSMutableArray array];
    }
    return _topicsArr;
}

#pragma mark- 设置列表属性
- (void)setUpTableView
{
    // tableView 设置内边距，达到穿透效果 ✨
    CGFloat top = FCTitlesViewY + FCTitlesViewHeighe;
    CGFloat bottom = self.tabBarController.tabBar.xmg_height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置tableview滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XMGColor(231, 231, 231);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTopicCell class]) bundle:nil] forCellReuseIdentifier:FCtopicsId];
    
    // 监听tabBar选中的通知（连续两次点击刷新）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:FCTabBarDidClickNotification object:nil];
}

#pragma mark- 实现通知方法
- (void)tabBarSelect
{
    // 如果是连续选中两次的话，直接刷新
    if (self.lastSelectIndex == self.tabBarController.selectedIndex && self.view.isShowingKeyWindow) {
        [self.tableView.header beginRefreshing];
    }
    
    // 记录这一次选中的索引
    self.lastSelectIndex = self.tabBarController.selectedIndex;
}

#pragma mark- 刷新加载
#pragma mark-
- (void)setUpRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNweTopis)];
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopis)];
    self.tableView.footer.hidden = YES;
}

#pragma mark- 刷新
- (void)loadNweTopis
{
    // 防止刷新加载冲突（结束上拉）
    [self.tableView.footer endRefreshing];
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"list";
    parames[@"c"] = @"data";
    parames[@"type"] = @(self.type);
    self.parame = parames;
    [self.manager GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.parame != parames) {
            return ;
        }
        // 在桌面创建一个plist文件，方便查看数据
//                [responseObject writeToFile:@"/Users/fangcun/Desktop/段子.plist" atomically:YES];
        // 存储maxtime（服务器加载要求使用参数）
        self.maxtime = responseObject[@"info"][@"maxtime"];
        self.topicsArr = [FCTopicModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        // 清空页码（防止页码错乱）
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
    }];
}

#pragma mark- 加载
- (void)loadMoreTopis
{
    // 防止刷新加载冲突（结束刷新）
    [self.tableView.header endRefreshing];
    self.page++;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"list";
    parames[@"c"] = @"data";
    parames[@"type"] = @(self.type); // 帖子类型为 29
    parames[@"page"] = @(self.page);
    parames[@"maxtime"] = self.maxtime;
    self.parame = parames;
    [self.manager GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.parame != parames) {
            return ;
        }
        // 存储maxtime（服务器加载要求使用参数）
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *newTopicsArr = [FCTopicModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 把加载出来的数据（newTopicsArr）加到整体数组中，从而实现上拉加载
        [self.topicsArr addObjectsFromArray:newTopicsArr];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
        // 加载失败恢复页码，防止页码丢失
        self.page--;
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果数据等于0上拉加载隐藏，否则反之
    self.tableView.footer.hidden = (self.topicsArr.count == 0);
    return self.topicsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCTopicModel *topicModel = self.topicsArr[indexPath.row];
    // cell高度计算在Model.m中
    return topicModel.cellHeigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:FCtopicsId];
    cell.topic  = self.topicsArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCCommentViewController *comment = [[FCCommentViewController alloc] init];
    comment.topic = self.topicsArr[indexPath.row];
    [self.navigationController pushViewController:comment animated:YES];
}


@end
