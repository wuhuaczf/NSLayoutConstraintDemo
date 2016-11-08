//
//  ViewController.m
//  AutoLayout
//
//  Created by 唐伟 on 16/11/7.
//  Copyright © 2016年 陈章峰. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * button1;
@property (nonatomic, strong) UIButton * button2;
@property (nonatomic, assign) BOOL isMas; // 判断是否是Masonry约束

@end

@implementation ViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化
- (void) initData {
    _isMas = NO;
    
    _button1 = [UIButton new];
    [_button1 setTitle:@"点我" forState:0];
    [_button1 setTitleColor:[UIColor blackColor] forState:0];
    [_button1 addTarget:self action:@selector(updateConstraints) forControlEvents:UIControlEventTouchUpInside];
    // 关闭自动约束，必须关闭
    _button1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_button1];
    
    _button2 = [UIButton new];
    [_button2 setTitleColor:[UIColor blackColor] forState:0];
    [_button2 setTitle:@"就不点" forState:0];
    // 关闭自动约束
    _button2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_button2];
    
    // 约束
//    [self constraintsWithItem];
//    [self constraintsWithFormat];
    [self constraintsWithMas];
}

#pragma mark 约束
- (void) constraintsWithItem {
    // 创建约束
    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:_button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:30];
    NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem:_button1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:30];
    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:_button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:70];
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:_button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:40];
    
    NSLayoutConstraint * top1Constraint = [NSLayoutConstraint constraintWithItem:_button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:130];
    NSLayoutConstraint * left1Constraint = [NSLayoutConstraint constraintWithItem:_button2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:30];
    NSLayoutConstraint * width1Constraint = [NSLayoutConstraint constraintWithItem:_button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:70];
    NSLayoutConstraint * height1Constraint = [NSLayoutConstraint constraintWithItem:_button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:40];
    
    // 添加约束
    [_button1 addConstraints:@[widthConstraint, heightConstraint]];
    [_button2 addConstraints:@[width1Constraint, height1Constraint]];
    [self.view addConstraints:@[topConstraint, leftConstraint, top1Constraint, left1Constraint]];
}

- (void) constraintsWithFormat {
    
    NSDictionary * viewsDic = @{@"button1":_button1, @"button2":_button2};

    NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[button1]-(30)-[button2(button1)]-(30)-|" options:0 metrics:@{@"width":@(70)} views:viewsDic];
    NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[button1(height)]-(30)-[button2(40)]" options:0 metrics:@{@"height":@(40)} views:viewsDic];
    
    // button1和button2左对齐
//    CGFloat W = self.view.frame.size.width;
//    NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[button1(width)]" options:0 metrics:@{@"width":@(W - 60)} views:viewsDic];
//    NSArray * h2Constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[button2(width)]" options:0 metrics:@{@"width":@(W - 60)} views:viewsDic];
//    NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[button1(height)]-(30)-[button2(40)]" options:0 metrics:@{@"height":@(40)} views:viewsDic];
    
//    [self.view addConstraints:h2Constraints];
    [self.view addConstraints:hConstraints];
    [self.view addConstraints:vConstraints];
}

- (void) constraintsWithMas {
    _isMas = YES;
    __weak typeof(self) weakSelf = self;
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
        make.width.mas_equalTo(70);
        make.height.equalTo(@40);
    }];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.button1.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.button1.mas_left);
        make.width.equalTo(weakSelf.button1.mas_width);
        make.height.equalTo(weakSelf.button1.mas_height);
    }];
}

#pragma mark 点击事件
- (void) updateConstraints {
    __weak typeof(self) weakSelf = self;
    
    if (_isMas) {
        [UIView animateWithDuration:1 animations:^{
            [weakSelf.button1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view.mas_top).offset(100);
            }];
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            for (NSLayoutConstraint * constraint in weakSelf.view.constraints) {
                if (constraint.firstItem == weakSelf.button1 && constraint.firstAttribute == NSLayoutAttributeTop) {
                    constraint.constant = 100;
                    break;
                }
            }
            [weakSelf.view updateConstraintsIfNeeded];
        }];
    }
}

@end
