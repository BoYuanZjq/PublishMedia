//
//  UICustomTextView.m
//  EvaluateDemo
//
//  Created by Zhang Jianqiang on 15/3/17.
//  Copyright (c) 2015年 Zhang Jianqiang. All rights reserved.
//

#import "UICustomTextView.h"
@interface UICustomTextView()
{
}
@property(nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation UICustomTextView
@synthesize placeholderColor,placeholder,placeHolderLabel;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    //self.placeHolderLabel.hidden = self.hasText;
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}
- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
        
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = [UIFont systemFontOfSize:16];
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
            
        }
        placeHolderLabel.text = self.placeholder;
        
        [placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:placeHolderLabel];
        
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
