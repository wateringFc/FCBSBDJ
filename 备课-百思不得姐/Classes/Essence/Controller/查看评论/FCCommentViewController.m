//
//  FCCommentViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCCommentViewController.h"
#import "XMGTopicCell.h"
#import "FCTopicModel.h"
#import "FCComment.h"
#import "FCCommensHeaderView.h"
#import "FCCommentCell.h"
//static NSInteger const FcHeaderLabelTag = 99;
static NSString *const FcCommentCellId = @"comment";
@interface FCCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bootomH;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最热评论 */
@property (strong, nonatomic) NSArray *hotComments;
/** 最新评论 */
@property (strong, nonatomic) NSMutableArray *latestComments;
/** 保存帖子的top_cmf */
@property (strong, nonatomic) NSArray *saved_top_Cmt;
/** 保存当前页码 */
@property (assign, nonatomic) NSInteger page;
/** 当前选中的行号(meun) */
@property (strong, nonatomic) NSIndexPath *selected;

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation FCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUptableviewHeder];
    
    [self setUpRefresh];
}


-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


#pragma mark - 视图基础设置
- (void)setUpTableView
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableView.backgroundColor = FCGlobalColor;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCCommentCell class]) bundle:nil] forCellReuseIdentifier:FcCommentCellId];
    // cell自动计算高度(iOS8以后才能使用)
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // tableview隐藏分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示/隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束(屏幕的高度 - 键盘的Y值)
    self.bootomH.constant = SCREENHEIGHT - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark- 销毁控制器时调用
- (void)dealloc
{
    // 销毁键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子top_cmt
    if (self.saved_top_Cmt.count) {
        // 控制器销毁时 saved_top_Cmt 赋值给 topic.top_cmt（就是中转了一下） 3
        self.topic.top_cmt = self.saved_top_Cmt;
        // kvc清零，返回的时候然模型重新计算cell高度，不然会出现bug
        [self.topic setValue:@0 forKey:@"cellHeigth"];
    }
    
    // 在控制器销毁时（返回）结束本控制器所有请求
    [self.manager invalidateSessionCancelingTasks:YES];
}


#pragma mark- 设置tableview的头部
- (void)setUptableviewHeder
{
    // 创建header（把cell添加到view上就可以自己处理header的高度问题）
    UIView *header = [[UIView alloc] init];
    
    // 清空top_cmt(cell上最热评论，本类不需要显示)
    if (self.topic.top_cmt.count) {
        // 赋值给 saved_top_Cmt    1
        self.saved_top_Cmt = self.topic.top_cmt;
        // 清空掉 top_cmt    2
        self.topic.top_cmt = nil;
        // 因为在模型中设置的属性为只读，所有只能通过kvc进行修改
        [self.topic setValue:@0 forKey:@"cellHeigth"];
    }
    
    // 添加cell
    XMGTopicCell *cell = [XMGTopicCell showCell];
    cell.topic = self.topic;
    cell.xmg_size = CGSizeMake(SCREENWIDTH, self.topic.cellHeigth);
    [header addSubview:cell];
    
    // header的高度
    header.xmg_height = self.topic.cellHeigth + FCTopicCellMargin;
    
    self.tableView.tableHeaderView = header;
}

#pragma mark- 刷新、加载
- (void)setUpRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.footer.hidden = YES;
}

// 刷新
- (void)loadNewComments
{
    // 请求之前结束所有正在执行的网络请求（调用 cancel（AF系统方法） 方法后会执行请求失败中代码）
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self.tableView.footer endRefreshing];
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"dataList";
    parames[@"c"] = @"comment";
    parames[@"data_id"] = self.topic.ID;
    parames[@"hot"] = @"1";
    
    [self.manager GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.page = 1;
        
        // 最热评论
        self.hotComments = [FCComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [FCComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        // 查看是否全部加载完毕
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            [self.tableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        [self.tableView.header endRefreshing];
    }];
}

// 加载
- (void)loadMoreComments
{
    // 请求之前结束所有正在执行的网络请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self.tableView.header endRefreshing];
    NSInteger page = self.page + 1;
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"dataList";
    parames[@"c"] = @"comment";
    parames[@"data_id"] = self.topic.ID;
    parames[@"page"] = @(page);
    FCComment *cmt = [self.latestComments lastObject];
    parames[@"lastcid"] = cmt.ID;
    
    [self.manager GET:XMGMainURL parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 页码
        self.page = page;
        
        // 最新评论
        NSArray *Comments = [FCComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:Comments];
        
        [self.tableView reloadData];
        
        // 查看是否全部加载完毕
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            [self.tableView.footer noticeNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark - 自定义方法
/**
 *  返回第section段的所有评论数组
 */
- (NSArray *)commentsInsection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count? self.hotComments:self.latestComments;
    }
    return self.latestComments;
}

- (FCComment *)commentsInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInsection:indexPath.section][indexPath.row];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latesCount = self.latestComments.count;
    // 上拉加载显示与否
    tableView.footer.hidden = (latesCount == 0);
    
    if (hotCount) { // 有“最热评论” + “最新评论”
        return 2;
    }
    if (latesCount) { // 有"最新评论"
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latesCount = self.latestComments.count;
    if (section == 0) {
        return hotCount? hotCount:latesCount;
    }
    // 非第0组
    return latesCount;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:FcCommentCellId];
    cell.comment = [self commentsInIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *Id = @"header";
    // 先从缓存池中找header
    FCCommensHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Id];
    if (!header) {
        header = [[FCCommensHeaderView alloc] initWithReuseIdentifier:Id];
    }
    // 设置label的数据
    NSInteger hotCommet = self.hotComments.count;
    if (section == 0) {
        header.title = hotCommet ? @"最热评论" : @"最新评论";
    }else{
        header.title = @"最新评论";
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    // 不进行重复显示
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
        return;
    }else {
        // 被点击的cell
        FCCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // 出现一个第一响应者
        [cell becomeFirstResponder];
        
        // 自定义显示文字
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        // 由于 menu 是sharedMenuController 在其他地方调用这个控制器也会显示，除非把  menu.menuItems = @[ding, replay, report]; 清空
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.xmg_height * 0.5, cell.xmg_width, cell.xmg_height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate
// 监听tableview是否滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    // tableview滑动的时候UIMenuController消失
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - 实现方法
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FCLog(@"顶 第%zd行  %@", indexPath.row, [self commentsInIndexPath:indexPath].content);
    
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FCLog(@"回复 第%zd行  %@", indexPath.row, [self commentsInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FCLog(@"举报 第%zd行  %@", indexPath.row, [self commentsInIndexPath:indexPath].content);
}




//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
// 一般方法设置header文字
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = FCGlobalColor;
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = XMGColor(67, 67, 67);
//    label.xmg_x = FCTopicCellMargin;
//    label.xmg_width = 200;
//    // 跟随父控件拉伸
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    label.font = [UIFont systemFontOfSize:14];
//    [view addSubview:label];
//    NSInteger hotCommet = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCommet ? @"最热评论" : @"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return view;


// 当header很多时候，可以进行复用调用header
//    static NSString *Id = @"header";
//    // 先从缓存池中找header
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Id];
//    UILabel *label = nil;
//    if (!header) {
//        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:Id];
//        header.contentView.backgroundColor = FCGlobalColor;
//        // 创建label
//        label = [[UILabel alloc] init];
//        label.textColor = XMGColor(67, 67, 67);
//        label.xmg_x = FCTopicCellMargin;
//        label.xmg_width = 200;
//        // 跟随父控件拉伸
//        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        label.font = [UIFont systemFontOfSize:14];
//        [header.contentView addSubview:label];
//    }else{
//        label = (UILabel *)[header viewWithTag:FcHeaderLabelTag];
//    }
//    // 设置label的数据
//    NSInteger hotCommet = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCommet ? @"最热评论" : @"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return header;

//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
