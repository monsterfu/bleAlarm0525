//
//  ConnectionManager.m
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ConnectionManager.h"

#define TRANSFER_SERVICE_UUID @"1802"
#define TRANSFER_CHARACTERISTIC_UUID    @"2A06"

@implementation ConnectionManager
@synthesize manager;

static ConnectionManager *sharedConnectionManager;

+ (ConnectionManager*) sharedInstance
{
    if (sharedConnectionManager == nil)
    {
        sharedConnectionManager = [[ConnectionManager alloc]initWithDelegate:nil];
    }
    return sharedConnectionManager;
}
- (ConnectionManager*) initWithDelegate:(id<ConnectionManagerDelegate>) delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        
//        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alertsound" ofType:@"wav"];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &_soundID);
        
        _localAskFoundNotice = [[UILocalNotification alloc] init];
        
        
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
        _peripheralDictionary = [NSMutableDictionary dictionary];
        _characteristicDictionary = [NSMutableDictionary dictionary];
        
        _addedDeviceArray = [NSMutableArray array];
        _newsDeviceArray = [NSMutableArray array];
        
        _deviceManagerDictionary = [NSMutableDictionary dictionary];
        
        
        warningStrength = 0;
        
        NSData* aData = [USER_DEFAULT objectForKey:KEY_DEVICELIST_INFO];
        _addedDeviceArray = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
        if (_addedDeviceArray == nil) {
            _addedDeviceArray = [NSMutableArray array];
        }else{
            
            for (deviceInfo* device in _addedDeviceArray) {
                [_deviceManagerDictionary setObject:device forKey:device.identifier];
                
                device.connected = NO;
                
            }
        }
        
        warningStrengthCheckTimer = [NSTimer timerWithTimeInterval:4.0f target:self selector:@selector(outOfRangeWarning) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:warningStrengthCheckTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark -scan
- (void) startScanForDevice
{
    NSDictionary* scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    
    // Make sure we start scan from scratch
    [manager stopScan];
    
    [manager scanForPeripheralsWithServices:nil options:scanOptions];
}

- (void) stopScanForDevice
{
    [manager stopScan];
}

#pragma mark - alarmFuc
-(void)outOfRangeWarning
{
    if (!checkDevice) {
        return;
    }
    if ([checkDevice.warningStrength floatValue] > warningStrength + 5) {
        return;
    }
    if (checkDevice.open) {
        [self.delegate didOutofRangWithDevice:checkDevice];
        [self scheduleOutOfRangeNotification:checkDevice];
    }
}
#pragma mark - fuction

- (void) removeDevice:(deviceInfo*)device
{
    if (device.connected) {
        [self.manager cancelPeripheralConnection:[_peripheralDictionary objectForKey:device.identifier]];
    }
}
-(BOOL)findDevice:(NSString*)name isOn:(BOOL)on
{
    BOOL result = NO;
    uint8_t val;
    if (on) {
        val = 2;
    }else{
        val = 0;
    }
    NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    
    CBPeripheral* peripheralss = [_peripheralDictionary objectForKey:name];
    CBCharacteristic* characterisiticss = [_characteristicDictionary objectForKey:name];
    
    if (peripheralss && characterisiticss) {
        [peripheralss writeValue:valData forCharacteristic:characterisiticss type:CBCharacteristicWriteWithoutResponse];
        result = YES;
    }
    return result;
}

-(void)scheduleOutOfRangeNotification:(deviceInfo*)device
{
    if (!_localOutOfRangeNotice) {
        _localOutOfRangeNotice = [[UILocalNotification alloc] init];
    }
    if ([[UIApplication sharedApplication]applicationState] != UIApplicationStateBackground) {
        return;
    }
    _localOutOfRangeNotice.applicationIconBadgeNumber = 1;
    _localOutOfRangeNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    _localOutOfRangeNotice.timeZone = [NSTimeZone defaultTimeZone];
    _localOutOfRangeNotice.soundName = @"4031.wav";
    _localOutOfRangeNotice.repeatInterval = NSDayCalendarUnit;
    
    _localOutOfRangeNotice.alertBody = [NSString stringWithFormat:@"%@已超出范围",device.idString];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:_localOutOfRangeNotice];
}

-(void)scheduleAskFoundNotification:(deviceInfo*)device
{
    if (_localAskFoundNotice) {
        [[UIApplication sharedApplication]cancelLocalNotification:_localAskFoundNotice];
    }
    if ([[UIApplication sharedApplication]applicationState] != UIApplicationStateBackground) {
        return;
    }
    _localAskFoundNotice.applicationIconBadgeNumber = 1;
    _localAskFoundNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    _localAskFoundNotice.timeZone = [NSTimeZone defaultTimeZone];
    _localAskFoundNotice.soundName = @"4031.wav";
    _localAskFoundNotice.repeatInterval = NSDayCalendarUnit;
    
    _localAskFoundNotice.alertBody = [NSString stringWithFormat:@"%@想要找到你",device.idString];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:_localAskFoundNotice];
}

#pragma mark - perprial delegate
#pragma mark - ble delegates
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripherals
{
    // Opt out from any other state
    if (peripherals.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyWriteWithoutResponse
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    
    //    CBMutableCharacteristic* transferCharacteristicOne = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"2A07"]
    //                                                                properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite
    //                                                                     value:nil
    //                                                               permissions:CBAttributePermissionsReadable];
    //    CBMutableCharacteristic* transferCharacteristicTwo = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"2A08"]
    //                                                                                         properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite
    //                                                                                              value:nil
    //                                                                                        permissions:CBAttributePermissionsReadable];
    
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"w ca ni");
    
    CBATTRequest* request = (CBATTRequest*)[requests objectAtIndex:0];
    deviceInfo* device = [_deviceManagerDictionary objectForKey:[request.central.identifier UUIDString]];
    if (device) {
        [self.delegate didDeviceWanaFindMe:device];
        [self scheduleAskFoundNotification:device];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest :%@",request);
}

- (void)peripheralManager:(CBPeripheralManager *)arg_peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"central:%@,characteristic:%@,%d,%@",central,characteristic.UUID,characteristic.properties,characteristic.value);
    
    uint8_t val = 2;
    NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    [arg_peripheral updateValue:valData forCharacteristic:characteristic onSubscribedCentrals:@[central]];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}

#pragma mark - center delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            if ([central state] == CBCentralManagerStatePoweredOn)
            {
                [_delegate isBluetoothEnabled:YES];
            }
            else
            {
                [_delegate isBluetoothEnabled:NO];
            }
            
            NSLog(@"CBCentralManagerStatePoweredOn");
        }
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
            
        default:
            NSLog(@"CM did Change State");
            
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)args_peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"Discovered peripheral, name %@, data: %@, RSSI: %f", [args_peripheral name], advertisementData, RSSI.floatValue);
    
    //屏蔽不可连接设备
    BOOL connectable = [[advertisementData objectForKey:@"kCBAdvDataIsConnectable"]boolValue];
    if (!connectable) {
        return;
    }
    
    //屏蔽已连接设备
//    if ([_peripheralDictionary objectForKey:args_peripheral.identifier]) {
//        return;
//    }
    
    //屏蔽无服务设备
    NSArray *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (!serviceData)
    {
        NSLog(@"Discovered unknown device, %@", [args_peripheral name]);
        return;
    }
    if (![_peripheralDictionary objectForKey:[args_peripheral.identifier UUIDString]]) {
        [_peripheralDictionary setObject:args_peripheral forKey:[args_peripheral.identifier UUIDString]];
        NSLog(@"args_peripheral:%@",args_peripheral);
        [manager connectPeripheral:args_peripheral options:nil];
        
        devInfo = [deviceInfo deviceWithId:args_peripheral.name identifier:[args_peripheral.identifier UUIDString]];
        [devInfo.locationCoordArray addObject:[deviceDisconnectInfo shareInstanceWithLocation:_location date:[NSDate date]]];
        
        BOOL isFound = NO;
        for (deviceInfo* added in _addedDeviceArray) {
            if ([added.identifier isEqualToString:[args_peripheral.identifier UUIDString]]) {
                isFound = YES;
            }
        }
        if (!isFound) {
            [_newsDeviceArray addObject:devInfo];
            [_deviceManagerDictionary setObject:devInfo forKey:devInfo.identifier];
        }
    }
    
    [self.delegate didDiscoverDevice:devInfo];
    
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)arg_peripheral error:(NSError *)error{
    NSLog(@"Connecting Fail: %@",error);
    [manager connectPeripheral:arg_peripheral options:nil];
}

-(void)disconnectNotice:(NSTimer*)timer
{
    deviceInfo* device = (deviceInfo*) [timer userInfo];
    [self.delegate didDisconnectWithDevice:device];
    [self scheduleOutOfRangeNotification:device];
    [device.locationCoordArray addObject:[deviceDisconnectInfo shareInstanceWithLocation:_location date:[NSDate date]]];
    
    [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_addedDeviceArray];
    [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
    [USER_DEFAULT synchronize];
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)persipheral error:(NSError *)error
{
    NSLog(@"disconnect!!!!");
    
    
    [manager connectPeripheral:persipheral options:nil];
    
    deviceInfo* device = [_deviceManagerDictionary objectForKey:[persipheral.identifier UUIDString]];
    if (!device.open) {
        return;
    }
    device.connected = NO;
    if (device) {
        if (disconnectTimer) {
            return;
        }
        disconnectTimer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(disconnectNotice:) userInfo:device repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:disconnectTimer forMode:NSDefaultRunLoopMode];
    }
    
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)arg_peripheral error:(NSError *)error
{
    NSLog(@"[[[[[[[[[[[[[[[peripheral.ddd:%f]]]]]]]]]]]]]]]",[arg_peripheral.RSSI floatValue]);
    checkDevice = [_deviceManagerDictionary objectForKey:[arg_peripheral.identifier UUIDString]];
    if (checkDevice) {
        checkDevice.signalStrength = arg_peripheral.RSSI;
        
        CGFloat meter = (-1)*[arg_peripheral.RSSI floatValue];
        
        if (meter < 30.0f) {
            meter = 31.0f;
        }
        if (warningStrength == 0) {
            warningStrength = meter;
        }
        //不停取均值
        warningStrength = (warningStrength + meter)/2;
        
        [checkDevice.delegate didUpdateData:checkDevice];
    }
    _peripheral = arg_peripheral;
    checkRssiTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateRSSIAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:checkRssiTimer forMode:NSDefaultRunLoopMode];
}

-(void)updateRSSIAction
{
    [_peripheral readRSSI];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)args_peripheral
{
    [args_peripheral setDelegate:self];
    [args_peripheral readRSSI];
    [args_peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"Error discover service: %@",[error localizedDescription]);
        return;
    }
    
    for(CBService *service in args_peripheral.services){
        NSLog(@"Service found with UUID: %@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]) {
            [args_peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
    deviceInfo* device = [_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]];
    device.connected = YES;
    [self.delegate didConnectWithDevice:device];
    [disconnectTimer invalidate];
    disconnectTimer = nil;
    
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error discover Character");
        //;
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            NSLog(@"Characteristic FOUND: %@ %@ %u",aChar.value,aChar.UUID,aChar.properties);
            
            /* Set notification on heart rate measurement */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]])
            {
                [args_peripheral setNotifyValue:YES forCharacteristic:aChar];
            }
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"Characteristic value : %@ with ID %@", characteristic.value, characteristic.UUID);
    
}


-(int)getRawValue:(Byte)highByte lowByte:(Byte)lowByte{
    
    int hi = (int)highByte;
    int lo = ((int)lowByte) & 0xFF;
    
    int return_value = (hi<<8) | lo;
    
    return return_value;
}


-(void)peripheral:(CBPeripheral *)args_peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"didUpdateNotificationStateForCharacteristic error:%@",error);
    }
    NSLog(@"characteristic.UUID:%@  value:%@, characteristic.properties:%d",characteristic.UUID,characteristic.value,characteristic.properties);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        [_characteristicDictionary setObject:characteristic forKey:[args_peripheral.identifier UUIDString]];
         [args_peripheral readValueForCharacteristic:characteristic];
    }
}


#pragma mark - CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];

    _location = newLocation;
//    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
//    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
//    NSLog(@"Lat: %@  Lng: %@", strLat, strLng);
    
//    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//    float zoomLevel = 0.02;
//    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
//    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
}
@end
