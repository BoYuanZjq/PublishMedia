//
//  FBFriendOperationMenuView.m
//  PublishMedia
//
//  Created by derek on 2017/11/23.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFriendOperationMenuView.h"
#import "UIView+SDAutoLayout.h"

#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

@interface FBFriendOperationMenuView ()
//点赞与取消点赞
@property (nonatomic, strong) UIButton *likeButton;
// 评论
@property (nonatomic, strong) UIButton *commentButton;
@end

@implementation FBFriendOperationMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = SDColor(69, 74, 76, 1);
    
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self addSubview:self.likeButton];
    [self addSubview:self.commentButton];
    [self addSubview:centerLine];
    CGFloat margin = 5;
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(.5);
    }];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeButton.mas_right);
        make.top.equalTo(self).offset(margin);
        make.bottom.equalTo(self).offset(-margin);
        make.width.equalTo(@1);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLine.mas_right).offset(margin);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.likeButton.mas_width);
    }];
    
//    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
//    CGFloat margin = 5;
//
//    _likeButton.sd_layout
//    .leftSpaceToView(self, margin)
//    .topEqualToView(self)
//    .bottomEqualToView(self)
//    .widthIs(80);
//
//    centerLine.sd_layout
//    .leftSpaceToView(_likeButton, margin)
//    .topSpaceToView(self, margin)
//    .bottomSpaceToView(self, margin)
//    .widthIs(1);
//
//    _commentButton.sd_layout
//    .leftSpaceToView(centerLine, margin)
//    .topEqualToView(_likeButton)
//    .bottomEqualToView(_likeButton)
//    .widthRatioToView(_likeButton, 1);
}


- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}
//- (void)setShow:(BOOL)show
//{
//    _show = show;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        if (!show) {
//            [self clearAutoWidthSettings];
//            self.sd_layout
//            .widthIs(0);
//        } else {
//            self.fixedWidth = nil;
//            [self setupAutoWidthWithRightView:_commentButton rightMargin:5];
//        }
//        [self updateLayoutWithCellContentView:self.superview];
//    }];
//}

#pragma mark - button event
- (void)likeButtonClicked {
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
   // self.show = NO;
}

- (void)commentButtonClicked {
    
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
  //  self.show = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
