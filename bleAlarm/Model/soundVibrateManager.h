//
//  soundVibrateManager.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface soundVibrateManager : NSObject
{
    CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
}

+ (soundVibrateManager*) sharedInstance;
- (void) playSystemSound;
- (void) playAlertSound;
- (void) vibrate;
@end
