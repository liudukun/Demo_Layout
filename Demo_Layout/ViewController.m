//
//  ViewController.m
//  Demo_Layout
//
//  Created by liudukun on 2017/2/14.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import "ViewController.h"
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()
{
    CGFloat normalWidth;
}

@property (nonatomic,strong) NSMutableArray *numberViews;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NEVPNManager *manager = [NEVPNManager sharedManager];
    [manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        // Put your codes here...
    }];
    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
    p.username = @"asdf";
    p.passwordReference = @"[VPN user password from keychain]";
    p.serverAddress = @"[Your server address]";
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    p.sharedSecretReference = @"[VPN server shared secret from keychain]";
    p.localIdentifier = @"[VPN local identifier]";
    p.remoteIdentifier = @"[VPN remote identifier]";
    p.useExtendedAuthentication = YES;
    p.disconnectOnSleep = NO;
    p.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"clientCert" ofType:@"p12"]];
    [manager setProtocol:p];
    [[NEVPNManager sharedManager] setOnDemandEnabled:YES];
    [[NEVPNManager sharedManager] setOnDemandEnabled:YES];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    NEOnDemandRuleConnect *connectRule = [NEOnDemandRuleConnect new];
    [rules addObject:connectRule];
    [[NEVPNManager sharedManager] setOnDemandRules:rules];
    [manager setLocalizedDescription:@"[You VPN configuration name]"];
    [manager saveToPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Save error: %@", error);
        }
        else {
            NSLog(@"Saved!");
        }
    }];
    
    NSError *startError;
    [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
    if(startError) {
        NSLog(@"Start error: %@", startError.localizedDescription);
    } else {
        NSLog(@"Connection established!");
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    normalWidth = (self.view.bounds.size.width - 5) / 4;
    self.numberViews = [NSMutableArray array];
    // add constrain
    for (int i=0; i<10; i++) {
        [self numberViewForString:[NSString stringWithFormat:@"%i",i]];
    }
    [self numberViewForString:@"."];
    [self numberViewForString:@"+"];
    [self numberViewForString:@"-"];
    [self numberViewForString:@"x"];
    [self numberViewForString:@"÷"];
    [self numberViewForString:@"="];
    [self numberViewForString:@"语言"];
    [self numberViewForString:@"清除"];

//    [self addConstraintsForCode];
//    [self addConstraintsForVLF];
    
    self.firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_firstLabel]-[_secondLabel]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_secondLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstLabel(20)]-20-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondLabel(20)]-20-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel)]];
    self.firstLabel.text = @"asf";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)numberViewForString:(NSString *)string{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, normalWidth, normalWidth);
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [self.numberViews addObject:button];
    return button;
}

- (void)addConstraintsForCode{

    // num = 0
    NSLayoutConstraint *left0 = [NSLayoutConstraint constraintWithItem:self.numberViews[0] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *width0 = [NSLayoutConstraint constraintWithItem:self.numberViews[0] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth*2+1];
    
    NSLayoutConstraint *height0 = [NSLayoutConstraint constraintWithItem:self.numberViews[0] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth];
    
    NSLayoutConstraint *bottom0 = [NSLayoutConstraint constraintWithItem:self.numberViews[0] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    
    left0.active = YES;
    width0.active = YES;
    height0.active = YES;
    bottom0.active = YES;
    
    
    // num = .
    NSLayoutConstraint *leftD = [NSLayoutConstraint constraintWithItem:self.numberViews[10] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[0] attribute:NSLayoutAttributeRight multiplier:1 constant:1];
    
    NSLayoutConstraint *widthD = [NSLayoutConstraint constraintWithItem:self.numberViews[10] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth];
    
    NSLayoutConstraint *heightD = [NSLayoutConstraint constraintWithItem:self.numberViews[10] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth];
    
    NSLayoutConstraint *bottomD = [NSLayoutConstraint constraintWithItem:self.numberViews[10] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    leftD.active = YES;
    widthD.active = YES;
    heightD.active = YES;
    bottomD.active = YES;
    
    
    // num = 1
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[1] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[1] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[1] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[1] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[1] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[0] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    

    
    // num = 2
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[2] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[1] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
 
    [NSLayoutConstraint constraintWithItem:self.numberViews[2] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[0] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[2] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[2] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    
    // num = 3
    [NSLayoutConstraint constraintWithItem:self.numberViews[3] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[3] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[0] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[3] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[3] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 4
    [NSLayoutConstraint constraintWithItem:self.numberViews[4] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[4] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[1] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[4] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[4] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[4] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 5
    [NSLayoutConstraint constraintWithItem:self.numberViews[5] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[4] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[5] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[1] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[5] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[5] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[5] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 6
    [NSLayoutConstraint constraintWithItem:self.numberViews[6] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[5] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[6] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[1] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[6] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[6] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[6] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 7
    [NSLayoutConstraint constraintWithItem:self.numberViews[7] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[7] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[4] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[7] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[7] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 8
    [NSLayoutConstraint constraintWithItem:self.numberViews[8] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[7] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[8] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[4] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[8] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[8] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    // num = 9
    [NSLayoutConstraint constraintWithItem:self.numberViews[9] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[8] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[9] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[4] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[9] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[9] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    
    // num = +
    [NSLayoutConstraint constraintWithItem:self.numberViews[11] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[10] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[11] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[3] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;

    [NSLayoutConstraint constraintWithItem:self.numberViews[11] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[11] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    // num = -
    [NSLayoutConstraint constraintWithItem:self.numberViews[12] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[11] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[12] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[6] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[12] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[12] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    // num = x
    [NSLayoutConstraint constraintWithItem:self.numberViews[13] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[12] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[13] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[9] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[13] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[13] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    // num = /
    [NSLayoutConstraint constraintWithItem:self.numberViews[14] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[13] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[14] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[14] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[14] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    // num = =
    NSLayoutConstraint *leftE = [NSLayoutConstraint constraintWithItem:self.numberViews[15] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[10] attribute:NSLayoutAttributeRight multiplier:1 constant:1];
    NSLayoutConstraint *rightE = [NSLayoutConstraint constraintWithItem:self.numberViews[15] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *heightE = [NSLayoutConstraint constraintWithItem:self.numberViews[15] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth];
    NSLayoutConstraint *bottomE = [NSLayoutConstraint constraintWithItem:self.numberViews[15] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    leftE.active = YES;
    rightE.active = YES;
    heightE.active = YES;
    bottomE.active = YES;
    //语言 16
    [NSLayoutConstraint constraintWithItem:self.numberViews[16] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[16] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[7] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[16] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[16] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[9] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
    //归零 17
    [NSLayoutConstraint constraintWithItem:self.numberViews[17] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.numberViews[16] attribute:NSLayoutAttributeRight multiplier:1 constant:1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[17] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.numberViews[8] attribute:NSLayoutAttributeTop multiplier:1 constant:-1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[17] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:normalWidth*2+1].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.numberViews[17] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.numberViews[2] attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
}


- (void)addConstraintsForVLF{
    
    // num = 0
    UIButton *button0 = self.numberViews[0];
    UIButton *button10 = self.numberViews[10];
    UIButton *button14 = self.numberViews[14];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button0]-1-[button10(normalWidth)]-1-[button14(==button10)]|" options:NSLayoutFormatAlignAllBottom metrics:@{@"normalWidth":@(normalWidth)} views:NSDictionaryOfVariableBindings(button0,button10,button14)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button0(normalWidth)]|" options:NSLayoutFormatAlignAllBottom metrics:@{@"normalWidth":@(normalWidth)} views:NSDictionaryOfVariableBindings(button0,button10,button14)]];
   
}




@end
