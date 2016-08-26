#import <UIKit/UIKit.h>

/** 精华->顶部标题高度 */
CGFloat const FCTitlesViewHeighe = 35;
/** 精华->顶部标题Y值 */
CGFloat const FCTitlesViewY = 64;
/** 精华->cell间距 */
CGFloat const FCTopicCellMargin = 10;
/** 精华->cell内容文字的Y值 */
CGFloat const FCTopicCellTextY = 55;
/** 精华->cell底部工具条的高度 */
CGFloat const FCTopicCellBottomBarH = 40;
/** 精华->cell图片帖子的最大高度 */
CGFloat const FCTopicCellPictureMaxH = 1000;
/** 精华->cell图片帖子一旦超过最大高度，就使用BreakH */
CGFloat const FCTopicCellPictureBreakH = 250;
/** FCUser模型 -> 性别属性值(男) */
NSString * const FCUserSexMale = @"m";
/** FCUser模型 -> 性别属性值(女) */
NSString * const FCUserSexFemle = @"f";
/** 精华->cell最热评论（“最热评论”文字高度） */
CGFloat const FCTopicCellTopCmtTitleH = 16;
/** tabBar被选中的通知 */
NSString * const FCTabBarDidClickNotification = @"FCTabBarDidClickNotification";
/** tabBar被选中的通知 - 被选中的控制器index key */
NSString * const FCSelectedControllerIndexKey = @"FCSelectedControllerIndexKey";
/** tabBar被选中的通知 - 被选中的控制器 key  */
NSString * const FCSelectedControllerKey = @"FCSelectedControllerKey";
/** 发段子 -> 标签间距 */
CGFloat const FCTagMargin = 5;