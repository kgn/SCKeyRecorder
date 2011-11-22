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
    [self.keyViewOne setKeysWithString:@"command+shift+u"];
    NSLog(@"%@", [self.keyViewOne keys]);
    [self.keyViewTwo setKeysWithArray:[NSArray arrayWithObjects:
                                      [SCKeyCommand key], @"opt", @"s", nil]];
    NSLog(@"%@", [self.keyViewTwo keys]);    
    [self.keyViewThree setKeysWithArray:[NSArray arrayWithObjects:
                                       [SCKeyControl key], @"up", nil]];
    NSLog(@"%@", [self.keyViewThree keys]);
}

@end
