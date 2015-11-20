//
//  Bluetooth.m
//  BluetoothController
//
//  Created by Matthieu Cherubini on 20/11/2015.
//  Copyright © 2015 Beach Creative. All rights reserved.
//

#import "Bluetooth.h"

@implementation Bluetooth
@synthesize cbcManager;

#define ARDUINO_SHIELD_NAME @"ZBModlue"
#define SHIELD_RW_CHARACTERISTIC @"FFC1"


-(void) start{
    cbcManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

-(void) sendValues:(NSString*)value{
    [self.peripheral writeValue:[value dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"Sent data %@ to %@", value, self.characteristic.UUID);
}

//Delegate showing discovered peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",peripheral.name);
    //Connect the central manager to the peripheral (Arduino Shield)
    if([peripheral.name isEqualToString:ARDUINO_SHIELD_NAME]){
        NSString *log = [NSString stringWithFormat:@"%@ found...", peripheral.name];
        NSLog(@"%@", log);
        [cbcManager stopScan];
        self.peripheral = peripheral;
        [cbcManager connectPeripheral:peripheral options:nil];
    }
}


//Delegate when a central manager successfully connected to a peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSString *log = [NSString stringWithFormat:@"Connecting to %@", peripheral.name];
    NSLog(@"%@",log);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString *connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", connected);
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if([characteristic.UUID.UUIDString isEqualToString:SHIELD_RW_CHARACTERISTIC]){
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"Found %@ characteristic", SHIELD_RW_CHARACTERISTIC);
            self.characteristic = characteristic;
        }
    }
}

//Delegate if fail to connect
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Error: %@", error.description);
}

//BLE State on the device
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *msg = @"";
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            msg=[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        case CBCentralManagerStateResetting:
            msg=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        case CBCentralManagerStateUnsupported:
            msg=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        case CBCentralManagerStateUnauthorized:
            msg=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        case CBCentralManagerStatePoweredOff:
            msg=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            break;
        case CBCentralManagerStatePoweredOn:
            msg=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
            [cbcManager scanForPeripheralsWithServices:nil options:options];
            break;
    }
    NSLog(@"%@", msg);
}
@end

