//
//  FBFriendContactLabel.m
//  PublishMedia
//
//  Created by derek on 2017/11/26.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFriendContactLabel.h"
@interface FBFriendContactLabel ()
@property(nonatomic,strong)UIColor *originalColor;
@end

@implementation FBFriendContactLabel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToCopy:)];
    [self addGestureRecognizer:longPress];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    if (self.originalColor==nil) {
        self.originalColor = backgroundColor;
    }
}
-(void)longPressToCopy:(UILongPressGestureRecognizer *)sender{
    if (sender.state==UIGestureRecognizerStateBegan) {
        [sender.view becomeFirstResponder];
        self.backgroundColor = [UIColor lightGrayColor];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:sender.view.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardHideNotice:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }else if (sender.state==UIGestureRecognizerStateCancelled){
        
    }else if (sender.state==UIGestureRecognizerStateChanged){
        
    }else if (sender.state==UIGestureRecognizerStateEnded){
        
    }
}
-(void)pasteboardHideNotice:(NSNotification *)obj{
    self.backgroundColor = self.originalColor;
    if (self) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSArray* methodNameArr = @[@"copy:"];
    if ([methodNameArr containsObject:NSStringFromSelector(action)]) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if (self.tag==1000) {
        if ([self.text containsString:@":"]) {
            NSRange mhRange = [self.text rangeOfString:@":"];
            pasteboard.string = [self.text substringFromIndex:mhRange.location+1];
            pasteboard.string = self.text;
        }else{
            pasteboard.string = self.text;
        }
    }else{
        pasteboard.string = self.text;
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