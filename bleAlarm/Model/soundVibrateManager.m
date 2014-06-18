//
//  soundVibrateManager.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "soundVibrateManager.h"

@implementation soundVibrateManager


static soundVibrateManager *sharedManager;

+ (soundVibrateManager*) sharedInstance
{
    if (sharedManager == nil)
    {
        sharedManager = [[soundVibrateManager alloc] initFile];
    }
    return sharedManager;
}

- (soundVibrateManager*)initFile
{
    if (self = [super init])
    {
        NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"4031"
                                                    withExtension: @"wav"];
        
        // Store the URL as a CFURLRef instance
        soundFileURLRef = (__bridge CFURLRef) tapSound;
        
        // Create a system sound object representing the sound file.
        AudioServicesCreateSystemSoundID (
                                          
                                          soundFileURLRef,
                                          &soundFileObject
                                          );
    }
    return self;
}


- (void) playSystemSound{
    
    AudioServicesPlaySystemSound (soundFileObject);
}


// Respond to a tap on the Alert Sound button.
- (void) playAlertSound {
    
    AudioServicesPlayAlertSound (soundFileObject);
}


// Respond to a tap on the Vibrate button. In the Simulator and on devices with no
//    vibration element, this method does nothing.
- (void) vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
@end
