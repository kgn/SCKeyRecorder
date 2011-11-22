//
//  SCAppDelegate.h
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCKeyView.h"

@interface SCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SCKeyView *keyViewOne;
@property (assign) IBOutlet SCKeyView *keyViewTwo;
@property (assign) IBOutlet SCKeyView *keyViewThree;

@end
