//
//  ViewController.h
//  BluetoothController
//
//  Created by mchrbn on 20/11/2015.
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

