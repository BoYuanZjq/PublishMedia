//
//  ChatKeyBoard.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/29.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "ChatKeyBoard.h"

#import "ChatToolBar.h"
#import "FacePanel.h"
#import "MorePanel.h"

#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"

#import "OfficialAccountToolbar.h"

#import "NSString+Emoji.h"

// 录音
#import "LGAudioKit.h"

static CGFloat canRecordTime = 60;


static inline CGFloat getSupviewH(CGRect keyboardInitialFrame)
{
    return keyboardInitialFrame.origin.y + kChatToolBarHeight;
}

static inline CGFloat getDifferenceH(CGRect keyboardInitialFrame)
{
    return kScreenHeight - (keyboardInitialFrame.origin.y + kChatToolBarHeight);
}

@interface ChatKeyBoard () <ChatToolBarDelegate, FacePanelDelegate, MorePannelDelegate>
{
    __weak UITableView *_associateTableView;    //chatKeyBoard关联的表
     Completion ComBlock;
}

@property (nonatomic, strong) ChatToolBar *chatToolBar;
@property (nonatomic, strong) FacePanel *facePanel;
@property (nonatomic, strong) MorePanel *morePanel;
@property (nonatomic, strong) OfficialAccountToolbar *OAtoolbar;

@property (nonatomic, assign) BOOL translucent;

/**
 *  键盘初始的frame
 */
@property (nonatomic, assign) CGRect keyboardInitialFrame;
/**
 *  聊天键盘 上一次的 y 坐标
 */
@property (nonatomic, assign) CGFloat lastChatKeyboardY;

/*
 * 时间计时器
 */
@property (nonatomic, weak) NSTimer *timerOf60Second;


@end

@implementation ChatKeyBoard

#pragma mark -- life

+ (instancetype)keyBoard
{
    return [self keyBoardWithNavgationBarTranslucent:YES];
}

/**
 *  如果导航栏是透明的，则键盘的初始位置为 kScreenHeight-kChatToolBarHeight
 *
 *  否则，导航栏的高度为 kScreenHeight-kChatToolBarHeight-64
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent
{
    CGRect frame = CGRectZero;
    if (translucent) {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    }else {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight - 64, kScreenWidth, kChatKeyBoardHeight);
    }
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds
{
    CGRect frame = CGRectMake(0, bounds.size.height - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    return [[self alloc] initWithFrame:frame];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.chatToolBar.frame"];
    [self removeObserver:self forKeyPath:@"self.frame"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _keyboardInitialFrame = frame;
        
        _chatToolBar = [[ChatToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kChatToolBarHeight)];
        _chatToolBar.delegate = self;
        [self addSubview:self.chatToolBar];
        
        _facePanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight-kFacePanelHeight, kScreenWidth, kFacePanelHeight)];
        _facePanel.delegate = self;
        [self addSubview:self.facePanel];
        
        _morePanel = [[MorePanel alloc] initWithFrame:self.facePanel.frame];
        _morePanel.delegate = self;
        [self addSubview:self.morePanel];
        
        _OAtoolbar = [[OfficialAccountToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kChatToolBarHeight)];
        [self addSubview:self.OAtoolbar];
        __weak __typeof(self) weakself = self;
        self.OAtoolbar.switchAction = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakself.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(weakself.frame), CGRectGetWidth(weakself.frame), kChatToolBarHeight);
                CGFloat y = weakself.frame.origin.y;
                y = getSupviewH(weakself.keyboardInitialFrame) - weakself.chatToolBar.frame.size.height;
                weakself.frame = CGRectMake(0, y, weakself.frame.size.width, weakself.frame.size.height);
            }];
        };
        
        self.lastChatKeyboardY = frame.origin.y;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self addObserver:self forKeyPath:@"self.chatToolBar.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"self.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

#pragma mark -- 跟随键盘的坐标变化
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 键盘已经弹起时，表情按钮被选择
    if (self.chatToolBar.faceSelected)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = YES;
            self.facePanel.hidden = NO;
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        } completion:nil];
    }
    // 键盘已经弹起时，more按钮被选择
    else if (self.chatToolBar.moreFuncSelected)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = NO;
            self.facePanel.hidden = YES;
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            CGFloat targetY = end.origin.y - (CGRectGetHeight(self.frame) - kMorePanelHeight) - getDifferenceH(self.keyboardInitialFrame);
            
            
            if(begin.size.height>0 && (begin.origin.y-end.origin.y>0))
            {
                // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                
                self.lastChatKeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                [self updateAssociateTableViewFrame];
                
            }
            else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘收起
                if (self.keyBoardStyle == KeyBoardStyleChat)
                {
                    self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    
                }else if (self.keyBoardStyle == KeyBoardStyleComment)
                {
                    if (self.chatToolBar.voiceSelected)
                    {
                        self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                    else
                    {
                        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                }
                [self updateAssociateTableViewFrame];
                
            }
            else if ((begin.origin.y-end.origin.y<0) && duration == 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘切换
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                [self updateAssociateTableViewFrame];
            }
            
        }];
    }
}

/**
 *  调整关联的表的高度
 */
- (void)updateAssociateTableViewFrame
{
    //表的原来的偏移量
    CGFloat original =  _associateTableView.contentOffset.y;
    
    //键盘的y坐标的偏移量
    CGFloat keyboardOffset = self.frame.origin.y - self.lastChatKeyboardY;
    
    //更新表的frame
    _associateTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.origin.y);
    //表的超出frame的内容高度
    CGFloat tableViewContentDiffer = _associateTableView.contentSize.height - _associateTableView.frame.size.height;
    
    
    //是否键盘的偏移量，超过了表的整个tableViewContentDiffer尺寸
    CGFloat offset = 0;
    if (fabs(tableViewContentDiffer) > fabs(keyboardOffset)) {
        offset = original-keyboardOffset;
    }else {
        offset = tableViewContentDiffer;
    }
    
    if (_associateTableView.contentSize.height +_associateTableView.contentInset.top+_associateTableView.contentInset.bottom> _associateTableView.frame.size.height) {
        _associateTableView.contentOffset = CGPointMake(0, offset);
    }
}
#pragma mark -- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.chatToolBar.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
        self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
        self.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), kChatToolBarHeight);
        
        [self updateAssociateTableViewFrame];
    }
}

#pragma mark -- ChatToolBarDelegate

/**
 *  语音按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar voiceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat y = self.frame.origin.y;
            y = getSupviewH(self.keyboardInitialFrame) - self.chatToolBar.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}

/**
 *  表情按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar faceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = YES;
        self.facePanel.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}

/**
 *  more按钮选中，此刻键盘没有弹起
 *  @param change  键盘是否弹起
 */
- (void)chatToolBar:(ChatToolBar *)toolBar moreBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = NO;
        self.facePanel.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}
- (void)chatToolBarSwitchToolBarBtnPressed:(ChatToolBar *)toolBar keyBoardState:(BOOL)change
{
    if (change == NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            
            CGFloat y = self.frame.origin.y;
            y = getSupviewH(self.keyboardInitialFrame) - kChatToolBarHeight;
            self.frame = CGRectMake(0,getSupviewH(self.keyboardInitialFrame), self.frame.size.width, self.frame.size.height);
            self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
    else
    {
        self.lastChatKeyboardY = self.frame.origin.y;
        
        CGFloat y = getSupviewH(self.keyboardInitialFrame) - kChatToolBarHeight;
        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), self.frame.size.width, self.frame.size.height);
        self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
        self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        
        [self updateAssociateTableViewFrame];
        
    }
}

- (void)chatToolBarDidStartRecording:(ChatToolBar *)toolBar
{
    //  开始录音
    [self startRecordVoice];
}
- (void)chatToolBarDidCancelRecording:(ChatToolBar *)toolBar
{
    // 取消录音
    [self cancelRecordVoice];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidCancelRecording:)]) {
        [self.delegate chatKeyBoardDidCancelRecording:self];
    }
}
- (void)chatToolBarDidFinishRecoding:(ChatToolBar *)toolBar
{
    // 录音结束
    [self confirmRecordVoice];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidFinishRecoding:)]) {
        [self.delegate chatKeyBoardDidFinishRecoding:self];
    }
}
- (void)chatToolBarWillCancelRecoding:(ChatToolBar *)toolBar
{
    // 将要取消录音
    [self updateCancelRecordVoice];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardWillCancelRecoding:)]) {
        [self.delegate chatKeyBoardWillCancelRecoding:self];
    }
}
- (void)chatToolBarContineRecording:(ChatToolBar *)toolBar
{
    // 继续录音
    [self updateContinueRecordVoice];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardContineRecording:)]) {
        [self.delegate chatKeyBoardContineRecording:self];
    }
}

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}

- (void)chatToolBarSendText:(NSString *)text
{
    [self.chatToolBar clearTextViewContent];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
}

- (void)chatToolBarTextViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
        [self.delegate chatKeyBoardTextViewDidChange:textView];
    }
}

- (void)chatToolBarTextViewDeleteBackward:(RFTextView *)textView
{
    NSRange range = textView.selectedRange;
    NSString *handleText;
    NSString *appendText;
    if (range.location == textView.text.length) {
        handleText = textView.text;
        appendText = @"";
    }else {
        handleText = [textView.text substringToIndex:range.location];
        appendText = [textView.text substringFromIndex:range.location];
    }
    
    if (handleText.length > 0) {
        
        [self deleteBackward:handleText appendText:appendText];
    }
}

#pragma mark -- FacePanelDelegate
- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName isDeleteKey:(BOOL)deletekey {
    NSString *text = self.chatToolBar.textView.text;
    
    if (deletekey == YES)
    {
        if (text.length <= 0) {
            [self.chatToolBar setTextViewContent:@""];
        }else {
            [self deleteBackward:text appendText:@""];
        }
    }else {
        [self.chatToolBar setTextViewContent:[text stringByAppendingString:faceName]];
    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardFacePicked:faceStyle:faceName:delete:)]) {
        [self.delegate chatKeyBoardFacePicked:self faceStyle:themeStyle faceName:faceName delete:deletekey];
    }
}
- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName faceAttributeName:(NSAttributedString *)attributeName isDeleteKey:(BOOL)deletekey
{
    NSString *text = self.chatToolBar.textView.text;
    
    if (deletekey == YES)
    {
        if (text.length <= 0) {
            [self.chatToolBar setTextViewContent:@""];
        }else {
            [self deleteBackward:text appendText:@""];
        }
    }else {
        [self.chatToolBar setTextViewContent:[text stringByAppendingString:faceName]];
    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardFacePicked:faceStyle:faceName:delete:)]) {
        [self.delegate chatKeyBoardFacePicked:self faceStyle:themeStyle faceName:faceName delete:deletekey];
    }
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel
{
    [self.chatToolBar clearTextViewContent];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.chatToolBar.textView.text];
    }
}

- (void)facePanelAddSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
        [self.delegate chatKeyBoardAddFaceSubject:self];
    }
}
- (void)facePanelSetSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
        [self.delegate chatKeyBoardSetFaceSubject:self];
    }
}

#pragma mark -- MorePannelDelegate
- (void)morePannel:(MorePanel *)morePannel didSelectItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoard:didSelectMorePanelItemIndex:)]) {
        [self.delegate chatKeyBoard:self didSelectMorePanelItemIndex:index];
    }
}
#pragma mark -- dataSource

- (void)setDataSource:(id<ChatKeyBoardDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardToolbarItems)]) {
        NSArray<ChatToolBarItem *> *barItems = [self.dataSource chatKeyBoardToolbarItems];
        [self.chatToolBar loadBarItems:barItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardMorePanelItems)]) {
        NSArray<MoreItem *> *moreItems = [self.dataSource chatKeyBoardMorePanelItems];
        [self.morePanel loadMoreItems:moreItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardFacePanelSubjectItems)]) {
        NSArray<FaceThemeModel *> *themeItems = [self.dataSource chatKeyBoardFacePanelSubjectItems];
        [self.facePanel loadFaceThemeItems:themeItems];
    }
}

#pragma mark -- set方法
- (void)setAssociateTableView:(UITableView *)associateTableView
{
    if (_associateTableView != associateTableView) {
        _associateTableView = associateTableView;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    [self.chatToolBar setTextViewPlaceHolder:placeHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    
    [self.chatToolBar setTextViewPlaceHolderColor:placeHolderColor];
}

-(void)setAllowVoice:(BOOL)allowVoice
{
    self.chatToolBar.allowVoice = allowVoice;
}

- (void)setAllowFace:(BOOL)allowFace
{
    self.chatToolBar.allowFace = allowFace;
}

- (void)setAllowMore:(BOOL)allowMore
{
    self.chatToolBar.allowMoreFunc = allowMore;
}

- (void)setAllowSwitchBar:(BOOL)allowSwitchBar
{
    self.chatToolBar.allowSwitchBar = allowSwitchBar;
}

- (void)setKeyBoardStyle:(KeyBoardStyle)keyBoardStyle
{
    _keyBoardStyle = keyBoardStyle;
    
    if (keyBoardStyle == KeyBoardStyleComment) {
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y+kChatToolBarHeight, self.frame.size.width, self.frame.size.height);
    }
}
- (void)setCustomButtonReplaceVoiceButton:(UIImage *)image withBlock:(Completion)com {
    if (ComBlock) {
        ComBlock = nil;
    }
    [self.chatToolBar.voiceBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.chatToolBar.allocVoiceEvent = YES;
    [self.chatToolBar.voiceBtn addTarget:self action:@selector(customEvent:) forControlEvents:UIControlEventTouchUpInside];
    ComBlock = com;
}

- (void)keyboardUp
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        [self.chatToolBar prepareForBeginComment];
        [self.chatToolBar.textView becomeFirstResponder];
    }
    else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardUpforComment" userInfo:nil];
        [excp raise];
    }
}


- (void)keyboardDown
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        if ([self.chatToolBar.textView isFirstResponder])
        {
            [self.chatToolBar.textView resignFirstResponder];
        }
        else
        {
            if((getSupviewH(self.keyboardInitialFrame) - CGRectGetMinY(self.frame)) > self.chatToolBar.frame.size.height)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.lastChatKeyboardY = self.frame.origin.y;
                    CGFloat y = self.frame.origin.y;
                    y = getSupviewH(self.keyboardInitialFrame) - self.chatToolBar.frame.size.height;
                    self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
                    
                    [self updateAssociateTableViewFrame];
                    
                }];
                
            }
        }
    }else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardDownForComment" userInfo:nil];
        [excp raise];
    }
}


- (void)keyboardUpforComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [self.chatToolBar prepareForBeginComment];
    [self.chatToolBar.textView becomeFirstResponder];
}

- (void)keyboardDownForComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.lastChatKeyboardY = self.frame.origin.y;
        
        [self.chatToolBar prepareForEndComment];
        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), self.frame.size.width, CGRectGetHeight(self.frame));
        
        [self updateAssociateTableViewFrame];
        
    } completion:nil];
}
// 自定义事件
- (void)customEvent:(UIButton*)sender {
    if (ComBlock) {
        ComBlock();
    }
}
#pragma mark - 回删表情或文字

- (void)deleteBackward:(NSString *)text appendText:(NSString *)appendText
{
    if (IsTextContainFace(text)) { // 如果最后一个是表情
        
        NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
        NSString *current = [text substringToIndex:startRang.location];
        [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
        self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        
    }else { // 如果最后一个系统键盘输入的文字
        
        if ([text isEmoji]) { // 如果是Emoji表情
            NSString *current = [text substringToIndex:text.length - 2];
            
            [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
            
        }else { // 如果是纯文字
            NSString *current = [text substringToIndex:text.length - 1];
            
            [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        }
    }
}


#pragma mark - Private Methods

// 取消录音
- (void)cancelRecordTimer {
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  开始录音
 */
- (void)startRecordVoice{
    // 先停止播放
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidStartRecording:)]) {
            [self.delegate chatKeyBoardDidStartRecording:self];
        }
        
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.superview recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
        // 如果用户不允许录音，那就直接取消
        [self cancelRecordVoice];
        [self.chatToolBar.recordBtn setButtonStateWithNormal];
        if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendAudioForbidden)]) {
            [self.delegate chatKeyBoardSendAudioForbidden];
        }
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < canRecordTime) {
        // 超过60s 自动发送
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self.superview];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}


/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [self cancelRecordTimer];
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.superview];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.superview];
}

/**
 录音最多60s
 */
- (void)sixtyTimeStopSendVodio {
    int countDown = canRecordTime - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown - 1];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= canRecordTime - 1 && [[LGSoundRecorder shareInstance] soundRecordTime] <= canRecordTime) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self.chatToolBar.recordBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)sendSound {
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendAudio:soundFilePath:)]) {
        
        [self.delegate chatKeyBoardSendAudio:[[LGSoundRecorder shareInstance] soundRecordTime] soundFilePath:[[LGSoundRecorder shareInstance] soundFilePath]];
    }
}


@end