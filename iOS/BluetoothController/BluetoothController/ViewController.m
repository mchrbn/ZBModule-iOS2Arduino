//
//  ViewController.m
//  BluetoothController
//
//  Created by mchrbn on 20/11/2015.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(IBAction)clickSend:(id)sender{
    //Send string from text box when button is pressed
    NSString *rotation = [NSString stringWithFormat:@"%@#%@", _txtAngle1.text, _txtAngle2.text];
    [bluetooth sendValues:rotation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init the bluetooth
    bluetooth = [[Bluetooth alloc] init];
    [bluetooth start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
