//
//  ConnectionManager.h
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "deviceInfo.h"
#import "GlobalHeader.h"
#import "deviceDisconnectInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@protocol ConnectionManagerDelegate
- (void) isBluetoothEnabled:(bool) enabled;
- (void) didDiscoverDevice:(deviceInfo*)device;
- (void) didDisconnectWithDevice:(deviceInfo*)device;
- (void) didConnectWithDevice:(deviceInfo*)device;
- (void) didOutofRangWithDevice:(deviceInfo*)device;
- (void) didDeviceWanaFindMe:(deviceInfo*)device on:(BOOL)on;
@end

@interface ConnectionManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate,CLLocationManagerDelegate>{
    
    Byte *tempbuffer;
    Byte chrisbuffer;
    int parserStatus;
    int payloadLength;
    int payloadBytesReceived;
    int payloadSum;
    int checksum;
    NSTimer* checkRssiTimer;
    deviceInfo* devInfo;
    CLLocationManager * _locationManager;
    CLLocation* _location;
    UILocalNotification *_localOutOfRangeNotice;  //超出距离通知
    UILocalNotification *_localAskFoundNotice;    //被找请求通知
    
    deviceInfo* checkDevice;
    CGFloat warningStrength;
    NSTimer* warningStrengthCheckTimer;
    
    NSTimer* disconnectTimer;
    
    
    BOOL _dialingSign;//来点提示音 开、关、开、关标记
    NSTimer* _dialingGapTimer;//来点提示音间隔
    CTCallCenter* callCenter1;
    CTCallCenter* callCenter2;
    
    CBUUID* _batteryUUID;
}
@property id<ConnectionManagerDelegate> delegate;
@property(nonatomic,strong)CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;

@property(nonatomic,strong)NSMutableData *data;
@property(nonatomic,strong)CBPeripheral *peripheral;
@property(nonatomic,retain)NSMutableDictionary* peripheralDictionary;
@property(nonatomic,retain)NSMutableDictionary* characteristicDictionary;

@property(nonatomic,retain)NSMutableArray* addedDeviceArray;
@property(nonatomic,retain)NSMutableArray* newsDeviceArray;

@property(nonatomic,retain)NSMutableDictionary* deviceManagerDictionary;
//@property(nonatomic,retain)NSMutableArray* addedDeviceArray;
//@property(nonatomic,retain)NSMutableArray* newDeviceArray;

+ (ConnectionManager*) sharedInstance;
- (void) startScanForDevice;
- (void) stopScanForDevice;
- (void) removeDevice:(deviceInfo*)device;
- (void) scheduleCallingState:(NSString*)stateStr;
- (BOOL) findDevice:(NSString*)name isOn:(BOOL)on;
@end
