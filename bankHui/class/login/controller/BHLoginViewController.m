//
//  BHLoginViewController.m
//  bankHui
//
//  Created by 王帅广 on 16/3/9.
//  Copyright © 2016年 王帅广. All rights reserved.
//

#import "BHLoginViewController.h"
#import "constant.h"

@interface BHLoginViewController ()

@property (nonatomic,strong) UITextField *nameTextField;

@property (nonatomic,strong) UITextField *passWordTextField;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation BHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

#pragma mark - UInterface
- (void)initUI
{
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.loginButton];
}

#pragma mark - Methord
- (void)didCLickLoginButton
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *tabbarVC = [storyBoard instantiateInitialViewController];
    
    [self presentViewController:tabbarVC animated:YES completion:nil];
    
}


#pragma mark - Getter
- (UITextField *)nameTextField
{
    if (_nameTextField == nil) {
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, SCREEHW - 40, 44)];
        _nameTextField.placeholder = @"请输入用户名";
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _nameTextField;
}

- (UITextField *)passWordTextField
{
    if (_passWordTextField == nil) {
        
        _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_nameTextField.frame) + 20, SCREEHW - 40, 44)];
        _passWordTextField.placeholder = @"请输入密码";
        _passWordTextField.returnKeyType = UIReturnKeyDone;
        _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
        
    }
    return _passWordTextField;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(SCREEHW / 2 - 40, CGRectGetMaxY(_passWordTextField.frame) + 20, 80, 40);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(didCLickLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}

#pragma mark - system
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
