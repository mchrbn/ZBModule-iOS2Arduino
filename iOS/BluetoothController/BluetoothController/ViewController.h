//
//  ViewController.h
//  BluetoothController
//
//  Created by Matthieu Cherubini on 16/11/2015.
//  Copyright © 2015 Beach Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bluetooth.h"

@interface ViewController : UIViewController{
    Bluetooth *bluetooth;
}

@property (strong, nonatomic) IBOutlet UITextField *txtAngle1;
@property (strong, nonatomic) IBOutlet UITextField *txtAngle2;
@property (strong, nonatomic) IBOutlet UILabel *lblLog;

@end

