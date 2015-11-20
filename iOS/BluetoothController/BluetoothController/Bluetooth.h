//
//  Bluetooth.h
//  BluetoothController
//
//  Created by Matthieu Cherubini on 20/11/2015.
//  Copyright © 2015 Beach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Bluetooth : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>{
    CBCentralManager *cbcManager;
}

-(void) start;
-(void) sendValues:(NSString*)value;

@property (readwrite, nonatomic) CBCentralManager *cbcManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *characteristic;

@end
