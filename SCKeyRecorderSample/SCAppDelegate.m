//
//  SCAppDelegate.m
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "SCAppDelegate.h"

@implementation SCAppDelegate

@synthesize window = _window;
@synthesize keyViewOne = _keyViewOne;
@synthesize keyViewTwo = _keyViewTwo;
@synthesize keyViewThree = _keyViewThree;

+ (void)initialize{
    if([self class] == [SCAppDelegate class]){
        NSDictionary *userDefaultsDictionary = 
        [NSDictionary dictionaryWithObject:@"command+shift+u" forKey:@"keyViewOne"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
    }
}

- (void)userDefaultsChanged:(NSNotification *)notification{
    [self.keyViewOne setKeysFromStandardUserDefaultForKey:@"keyViewOne"];
    NSLog(@"%@", [self.keyViewOne keysString]);    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self.keyViewOne setKeysFromStandardUserDefaultForKey:@"keyViewOne"];
    NSLog(@"%@", [self.keyViewOne keysString]);
    [self.keyViewTwo setKeysWithArray:[NSArray arrayWithObjects:
                                      [SCKeyCommand key], @"opt", @"s", nil]];
    NSLog(@"%@", [self.keyViewTwo keysString]);    
    [self.keyViewThree setKeysWithArray:[NSArray arrayWithObjects:
                                       [SCKeyControl key], @"up", nil]];
    NSLog(@"%@", [self.keyViewThree keysString]);
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(userDefaultsChanged:) 
     name:NSUserDefaultsDidChangeNotification object:nil];      
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [self.keyViewOne storeKeysInStandardUserDefaultForKey:@"keyViewOne"];
}

@end
