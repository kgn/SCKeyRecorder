//
//  SCAppDelegate.m
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//

#import "SCAppDelegate.h"

@implementation SCAppDelegate

@synthesize window = _window;
@synthesize keyViewOne = _keyViewOne;
@synthesize keyViewTwo = _keyViewTwo;
@synthesize keyViewThree = _keyViewThree;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self.keyViewOne setKeysWithString:@"cmd+shift+u"];
    [self.keyViewTwo setKeysWithArray:[NSArray arrayWithObjects:
                                      SCKeyCmd, SCKeyOpt, @"s", nil]];
    [self.keyViewThree setKeysWithArray:[NSArray arrayWithObjects:
                                       SCKeyCmd, SCKeyUp, nil]];
}

@end
