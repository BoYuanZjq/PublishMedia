//
//  FBFcDynamicTopCell.h
//  PublishMedia
//
//  Created by derek on 2017/11/21.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomTextView.h"

@class FBFcDynamicTopCell;

@protocol FBFcDynamicTopCellDelegate <NSObject>

- (void)addItem;
/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(FBFcDynamicTopCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;

/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 删除一个图片
 */
- (void)didSelectCloseItemAtIndexPath:(int)index;


/**
 转换图片
 
 @param fromIndex 从一个点
 @param toIndex 到另外一个点
 */
- (void)didMoveFromIndex:(NSIndexPath*)fromIndex toIndex:(NSIndexPath*)toIndex;

@end

@interface FBFcDynamicTopCell : UITableViewCell

@property (strong, nonatomic) UICustomTextView *textView;
// 网格
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, weak) id<FBFcDynamicTopCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *dataAry;




@end
