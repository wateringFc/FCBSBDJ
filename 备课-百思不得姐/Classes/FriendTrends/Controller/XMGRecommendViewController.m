//
//  XMGRecommendViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/23.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendViewController.h"
#import "XMGRecommendCategory.h"
#import "XMGRecommendUser.h"
#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendUserCell.h"
// 获取当前选中的类别(选中了左边哪个类别)
#define XMGSelectedCategory self.categoriesArr[[[self.categoryTableView indexPathForSelectedRow] row]]
static NSString *const XMGCategorId = @"category";
static NSString *const XMGUserId = @"user";

@interface XMGRecommendViewController () <UITableViewDataSource, UITableViewDelegate>
/**
 *  左边表格
 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

/**
 *  右边表格
 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/**
 *  左边表格数据
 */
@property (strong, nonatomic) NSArray *categoriesArr;

/**
 *  请求参数(用于短时间内用户多少点击发送请求,下拉刷新时)
 */
@property (strong, nonatomic) NSDictionary *params;

/**
 *  请求参数(用于短时间内用户多少点击发送请求,上拉加载时)
 */
@property (strong, nonatomic) NSMutableDictionary *mutParams;

/**
 *  请求管理者
 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation XMGRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpRefresh];
    [self setTabelView];
    [self loadLeftTabelViewData];
}


- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


#pragma mark- 页面初始化
#pragma mark-
- (void)setTabelView
{
    self.title = @"推荐关注";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = FCGlobalColor;
    
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    // 注册cell   [UINib nibWithNibName:NSStringFromClass([XMGRecommendCategoryCell class]) bundle:nil],把类名转换为字符串
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:XMGCategorId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:XMGUserId];
}

#pragma mark- 刷新加载
#pragma mark-
- (void)setUpRefresh
{
    // 控制器先刷新加载数据，提高用户体验
    self.userTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNweUsers)];
    
    /** 一般使用以下两种 加载模式
     *  MJRefreshBackNormalFooter 加载成功后 回弹隐藏
        MJRefreshAutoNormalFooter 不回弹隐藏
     */
    self.userTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    // 视图刚显示的时候隐藏
    self.userTableView.footer.hidden = YES;
}


#pragma mark- 下拉刷新 加载数据，提高用户体验
#pragma mark-
- (void)loadNweUsers
{
    XMGRecommendCategory *rc = XMGSelectedCategory;
    // 设置当前页码为 1
    rc.currentPage = 1;
    // 根绝左边选中的类别 请求右边数据
    NSDictionary *parame = @{@"a": @"list", @"c": @"subscribe", @"category_id":rc.id, @"page":@(rc.currentPage)};
    
    //  ⭐️《处理短时间内用户多少点击发送请求》 当第一次 用户点击 左边的类别1的时候，此时创建了类别1的parame，并self.params = parame把参数赋值给了self.params ，此时要进行请求的parame是类别1的parame； 与此同时，当把类别1 的parame发送给接口进行请求的时候，用户又点了 类别2，此时，又创建了类别2的parame，同理self.params = parame，此时的要进行请求的parame是类别2的parame了，所以在请求成功里边添加 if (self.params != parame) return; 如此操作后类别1的请求就会被return掉，直接进行 类别2 的网络请求，从而 解决了短时间内用户多次点击不同类别产生的多次请求。造成多次请求浪费的内存，也避免了，多次请求其中一个请求失败，提示“加载信息失败的”的问题。
    self.params = parame;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"~~~~~~~  %@",responseObject);
        
        // 1.字典数组 -> 模型数组
        NSArray *userArr = [XMGRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 清除所有旧数据(防止数据重复：⭐️)
        [rc.users removeAllObjects];
        // 2.添加到当前类别对应的用户数组中(解决重复请求问题：1)
        [rc.users addObjectsFromArray:userArr];
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        
        // 处理短时间内用户多少点击发送请求，当前不是最后一次请求（之前请求下来的数据也进行存储，但不进行刷新操作）
        if (self.params != parame) {
            return;
        }
        
        // 右边列表刷新
        [self.userTableView reloadData];
        // 数据请求成功后 结束下拉刷新
        [self.userTableView.header endRefreshing];
        // 当第一次已经全部请求完成之后，也应结束上拉加载的操作，因此在这也要做一个判读，检测底部加载控件显示状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 提示
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
        // 数据请求失败后 结束下拉刷新
        [self.userTableView.header endRefreshing];
    }];
}

#pragma mark - 上拉加载 更多用户数据
#pragma mark-
- (void)loadMoreUsers
{
    // 获取到左边选中的类别
    XMGRecommendCategory *category = XMGSelectedCategory;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"list";
    parames[@"c"] = @"subscribe";
    parames[@"category_id"] = category.id; // 左边类别的id
    parames[@"page"] = @(++category.currentPage);
    self.mutParams = parames;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {

        // 1.字典数组 -> 模型数组
        NSArray *userArr = [XMGRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 2.添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:userArr];
        
        // 同上解释
        if (self.mutParams != parames) {
            return;
        }
        
        // 3.刷新右边列表
        [self.userTableView reloadData];
        
        // 检测底部加载控件显示状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
        // 数据请求失败后 结束上拉加载
        [self.userTableView.footer endRefreshing];
    }];
}

#pragma mark- 左边类别列表数据
#pragma mark-
- (void)loadLeftTabelViewData
{
    // 显示等待显示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *parame = @{@"a": @"category", @"c": @"subscribe"};
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        // 1.隐藏指示器
        [SVProgressHUD dismiss];
        // 2.返回数据模型转数组
        self.categoriesArr = [XMGRecommendCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 3.刷新列表
        [self.categoryTableView reloadData];
        // 4.设置 左边tableview 默认选中第一个cell  UITableViewScrollPositionTop：设置选中之后显示到顶部
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        // 5.让右边列表进入刷新状态，（选中左边哪个类别就刷新哪个类别的数据，也是默认显示第一个选中数据，）
        [self.userTableView.header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败..."];
    }];
}


#pragma mark- 时刻检测foot的状态（继续加载/加载完成）
#pragma mark-
- (void)checkFooterState
{
    // 全部数据已经加载完毕时（此判断主要解决 当点击 左边一个分类的时候，此时分类数据已经全部加载完毕，tableview的Footer加载状态显示 “已经全部加载完毕” 而此时点击 左边另一个分类（需要加载数据的分类）时，tableview的foot加载状态显示错误（也显示“已经全部加载完毕”因显示“上拉加载更多数据”））
    XMGRecommendCategory *rc = XMGSelectedCategory;
    if (rc.users.count == rc.total) {
        [self.userTableView.footer noticeNoMoreData];
    }else{
        // 让底部控件结束刷新（）
        [self.userTableView.footer endRefreshing];
    }
}


#pragma mark - tabaleViewDelegate/dataSource
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categoriesArr.count;
    }else{
        // 检测footer的显示状态（⭐️）
        [self checkFooterState];
        
        XMGRecommendCategory *rc = XMGSelectedCategory;
        
        // 每次刷新右边数据时，都控制Footer显示或者隐藏
        self.userTableView.footer.hidden = (rc.users.count == 0);
        
        // 返回选中类别对应个数 (解决重复请求问题：3)
        return rc.users.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        // 左边表格
        XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCategorId];
        cell.category = self.categoriesArr[indexPath.row];
        return cell;
    }else{
        // 右边表格
        XMGRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGUserId];
        // (解决重复请求问题：4)
        cell.user = [XMGSelectedCategory users][indexPath.row];
        return cell;
    }
    
}

// 选中了哪个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.userTableView.header endRefreshing];
    
    // 选中cell之后
    if (tableView == self.categoryTableView) {
        // 结束刷新(当右边正在加载中，点击了左边的其它类别时候)
        [self.userTableView.footer endRefreshing];
        
        XMGRecommendCategory *categoryss = self.categoriesArr[indexPath.row];
        
        if (categoryss.users.count) {
            // 如果数组中有曾经请求的数据，表格直接刷新，不进行请求
            [self.userTableView reloadData];
        }else{
            // (解决网络慢显示上一残留数据)及时刷新表格，马上显示当前category的用户数据，不让用户看到上一个category的残留数据
            [self.userTableView reloadData];
            
            
            // 进入下拉刷新（将进入下拉刷新方法（loadNweUsers） -> 加载数据）
            [self.userTableView.header beginRefreshing];
        }
    }
    /** (两个tableView关联)主要面临问题
        1、重复发送请求
        2、无上拉加载
        3、如果网速慢，数据显示有问题
     */
}


#pragma mark- 控制器的销毁,防止控制器正在请求数据的同时，用户点击返回，此时控制器销毁，请求还在继续，此时就会发生程序崩溃问题
#pragma mark-
- (void)dealloc
{
    // 停止本控制器所有网络请求操作
    [self.manager.operationQueue cancelAllOperations];
}




@end
