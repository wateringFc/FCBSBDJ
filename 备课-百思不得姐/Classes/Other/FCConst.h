

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    FCTopicTypeAll = 1,
    FCTopicTypePicture = 10,
    FCTopicTypeWord = 29,
    FCTopicTypeVoice = 31,
    FCTopicTypeVideo = 41
} FCTopicType;

/** 精华->顶部标题高度 */
UIKIT_EXTERN CGFloat const FCTitlesViewHeighe;
/** 精华->顶部标题Y值 */
UIKIT_EXTERN CGFloat const FCTitlesViewY;
/** 精华->cell间距 */
UIKIT_EXTERN CGFloat const FCTopicCellMargin;
/** 精华->cell内容文字的Y值 */
UIKIT_EXTERN CGFloat const FCTopicCellTextY;
/** 精华->cell底部工具条的高度 */
UIKIT_EXTERN CGFloat const FCTopicCellBottomBarH;
/** 精华->cell图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const FCTopicCellPictureMaxH;
/** 精华->cell图片帖子一旦超过最大高度，就使用BreakH */
UIKIT_EXTERN CGFloat const FCTopicCellPictureBreakH;
/** FCUser模型 -> 性别属性值(男) */
UIKIT_EXTERN NSString * const FCUserSexMale;
/** FCUser模型 -> 性别属性值(女) */
UIKIT_EXTERN NSString * const FCUserSexFemle;
/** 精华->cell最热评论（“最热评论”文字高度) */
UIKIT_EXTERN CGFloat const FCTopicCellTopCmtTitleH;
/** tabBar被选中的通知 */
UIKIT_EXTERN NSString * const FCTabBarDidClickNotification;
/** tabBar被选中的通知 - 被选中的控制器index key */
UIKIT_EXTERN NSString * const FCSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key  */
UIKIT_EXTERN NSString * const FCSelectedControllerKey;
/** 发段子 -> 标签间距 */
UIKIT_EXTERN CGFloat const FCTagMargin;



