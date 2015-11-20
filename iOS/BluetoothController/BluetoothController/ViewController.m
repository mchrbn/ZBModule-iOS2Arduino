//
//  ViewController.m
//  BluetoothController
//
//  Created by Matthieu Cherubini on 16/11/2015.
//  Copyright © 2015 Beach Creative. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(IBAction)clickSend:(id)sender{
    //NSLog(@"%@ - %@", _txtAngle1.text, _txtAngle2.text);
    NSString *rotation = [NSString stringWithFormat:@"%@#%@", _txtAngle1.text, _txtAngle2.text];
    [bluetooth sendValues:rotation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bluetooth = [[Bluetooth alloc] init];
    [bluetooth start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
