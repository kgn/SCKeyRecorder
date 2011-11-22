//
//  SCAppDelegate.h
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//

#import <Cocoa/Cocoa.h>
#import "SCKeyView.h"

@interface SCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SCKeyView *keyViewOne;
@property (assign) IBOutlet SCKeyView *keyViewTwo;
@property (assign) IBOutlet SCKeyView *keyViewThree;

@end
