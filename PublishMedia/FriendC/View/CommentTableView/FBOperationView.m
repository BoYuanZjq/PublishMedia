//
//  FBOperationView.m
//  PublishMedia
//
//  Created by derek on 2017/11/29.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBOperationView.h"
@interface FBOperationView()
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}
@end

@implementation FBOperationView
-(instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor =  [UIColor colorWithRed:69.0/255.0 green:74.0/255.0 blue:76.0/255.0 alpha:1.0];
        
        _likeButton = [self createButtonWith:@"赞" image:@"AlbumLike" selImage:nil target:self selector:@selector(likeBtnDidTouch:)];
        _commentButton = [self createButtonWith:@"评论" image:@"AlbumComment" selImage:nil target:self selector:@selector(commentBtnDidTouch:)];
        UIView *centerLine = [[UIView alloc]init];
        centerLine.backgroundColor = [UIColor grayColor];
        
        [self addSubview:_likeButton];
        [self addSubview:_commentButton];
        [self addSubview:centerLine];
        
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(5);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(90);
        }];
        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(_likeButton.mas_right);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(1);
        }];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(centerLine.mas_right);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(90);
        }];
    }
    return self;
}

-(UIButton *)createButtonWith:(NSString *)title image:(NSString *)imageString selImage:(NSString *)selImageString target:(id)target selector:(SEL)sel {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImageString] forState:UIControlStateSelected];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

#pragma mark getter/setter

-(void)setIsShowing:(BOOL)isShowing {
    _isShowing = isShowing;
    if(isShowing) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(181);
        }];
    } else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.superview layoutIfNeeded];
    }];
}

-(void)setPraiseString:(NSString *)praiseString {
    _praiseString = praiseString;
    [_likeButton setTitle:praiseString forState:UIControlStateNormal];
}

#pragma  mark - 点击事件
-(void)likeBtnDidTouch:(UIButton*)sender{
    if (self.zanBtnClickBlock) {
        self.zanBtnClickBlock();
    }
}
-(void)commentBtnDidTouch:(UIButton*)sender {
    if(self.commentBtnClickBlock) {
        self.commentBtnClickBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
