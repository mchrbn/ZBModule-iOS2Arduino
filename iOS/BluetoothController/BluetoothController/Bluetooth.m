//
//  Bluetooth.m
//  BluetoothController
//
//  Created by mchrbn on 20/11/2015.
//

#import "Bluetooth.h"

@implementation Bluetooth
@synthesize cbcManager;

//Might have to change these values
#define ARDUINO_SHIELD_NAME @"ZBModlue"
#define SHIELD_RW_CHARACTERISTIC @"FFC1"

//Init the Bluetooth Service
-(void) start{
    cbcManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

//Call this method to send values over BLE
-(void) sendValues:(NSString*)value{
    [self.peripheral writeValue:[value dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"Sent data %@ to %@", value, self.characteristic.UUID);
}

//Step #1 : Delegate showing discovered peripherals
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


//Step #2 : Delegate when a central manager successfully connected to a peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSString *log = [NSString stringWithFormat:@"Connecting to %@", peripheral.name];
    NSLog(@"%@",log);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString *connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", connected);
}


//Step #3 : Delegate when a central manager start to look for services on a connected peripheral
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }}

//Step #4 : Delegate when a central manager start to look for characteristic on a service
//In the case of the ZBModule BLE Shield, the characteristic where values have to be sent is called FFC1
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

