//
//  SuggestController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/12.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "SuggestController.h"
#import "SuggestView.h"
#import "DDMenuController.h"
#import "AppDelegate.h"


@interface SuggestController ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, retain) SuggestView *rootView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain)     UILabel *label;
@end

@implementation SuggestController

- (void)dealloc {
    [_label release];
    [_textField release];
    [_rootView release];
    [super dealloc];
}
- (void)loadView {
    self.rootView = [[[SuggestView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _rootView;
}
- (void)viewDidLoad {
    self.label = [[[UILabel alloc]initWithFrame:CGRectMake(3, 4, 300, 20)] autorelease];
    self.label.enabled = NO;
    self.label.text = @"请反馈问题或建议，帮助我们不断改进！";
    self.label.font =  [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor colorWithRed:225 / 255.0 green:220 / 255.0 blue:225 / 255.0 alpha:1.0];
    [_rootView.content addSubview:self.label];

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.navigationItem.title = @"意见反馈";
    [self configureLeftButton];
    [self configureRightButton];
    _rootView.content.delegate = self;
    _rootView.email.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFileDelegate 

//点击空白区域，会触发的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //回收键盘
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate设置默认文字

- (void)textViewDidChange:(UITextView *)textView {
  
    if (textView.text.length == 0) {
        [self.label setHidden:NO];
    } else {
        [self.label setHidden:YES];
    }
}
#pragma mark - 界面配置类
- (void)configureLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
    
}
- (void)configureRightButton {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(handleSend:)];
    self.navigationItem.rightBarButtonItem = right;
    [right release];
    
}
- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}

- (void)handleSend:(UIBarButtonItem *)item {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"反馈提醒" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if (_rootView.content.text.length  < 5) {
        alert.message = @"别吝啬，多留点字吧~";
    } else {
        alert.message = @"反馈成功";
        _rootView.content.text = @"";
        _rootView.email.text = @"";
    }
    [alert show];
    [alert release];
}

@end
