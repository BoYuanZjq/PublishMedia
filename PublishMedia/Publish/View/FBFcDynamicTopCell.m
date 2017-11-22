//
//  FBFcDynamicTopCell.m
//  PublishMedia
//
//  Created by derek on 2017/11/21.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFcDynamicTopCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"

#define K_Cell @"cell"

@interface FBFcDynamicTopCell ()<UICollectionViewDelegate, UICollectionViewDataSource,LxGridViewDataSource>
@property (nonatomic, assign) CGFloat heightED;
@end

@implementation FBFcDynamicTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.heightED = 0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textView];
        self.textView.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 60);
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height-80);
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataAry.count == 0) {
         return 1;
    } else if(self.dataAry.count<9){
        return self.dataAry.count + 1;
    }else{
        return 9;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_Cell forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.gifLable.hidden = YES;
    cell.row = indexPath.row;
    if (self.dataAry.count==indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.imageView.backgroundColor = [UIColor clearColor];
    } else {
        cell.imageView.backgroundColor = [UIColor blackColor];
        cell.imageView.image = self.dataAry[indexPath.row];
        //        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
//    __weak typeof(self)weakSelf = self;
//    cell.didSelectedBlock = ^(NSInteger row) {
//        if (row == self.dataAry.count || row == 8) {
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addItem)]) {
//                [weakSelf.delegate addItem];
//            }
//        }else{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
//                NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
//                [weakSelf.delegate didSelectItemAtIndexPath:index];
//            }
//        }
//       
//    };
    // 更新高度
    [self updateCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = (TZTestCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.deleteBtn.isHidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(addItem)]) {
            [self.delegate addItem];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
            [self.delegate didSelectItemAtIndexPath:indexPath];
        }
    }
}

- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.heightED != height) {
        self.heightED = height;
        self.collectionView.frame = CGRectMake(0, 80, self.collectionView.frame.size.width, height);
        
        if (_delegate && [_delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height +80 andIndexPath:self.indexPath];
        }
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.dataAry.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.dataAry.count && destinationIndexPath.item < self.dataAry.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMoveFromIndex:toIndex:)]) {
        [self.delegate didMoveFromIndex:sourceIndexPath toIndex:destinationIndexPath];
    }

}


- (void)deleteBtnClik:(UIButton *)sender {
    
    int tag = (int)sender.tag;
    if (self.delegate && [_delegate respondsToSelector:@selector(didSelectCloseItemAtIndexPath:)]) {
        [self.delegate didSelectCloseItemAtIndexPath:tag];
    }
}

#pragma mark ====== init ======
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width;
        CGFloat height;
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            
            width = ([UIScreen mainScreen].bounds.size.width - 50) / 4;
            height = width;
            layout.itemSize = CGSizeMake(width, height);
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            
        }else{
            
            width = ([UIScreen mainScreen].bounds.size.width - 100) / 4;
            height = width;
            layout.itemSize = CGSizeMake(width, height);
            layout.sectionInset = UIEdgeInsetsMake(10, 20, 20, 20);
            
        }
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:K_Cell];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (UICustomTextView*)textView {
    if (!_textView) {
        _textView = [[UICustomTextView alloc] init];
        _textView.placeholder = @"这一刻的想法";
    }
    return _textView;
}
- (void)setDataAry:(NSArray *)dataAry {
    self.heightED = 0;
    _dataAry = [NSArray arrayWithArray:dataAry];
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
