//
//  SCKeyView.h
//  SCKeyRecorderSample
//
//  Created by David Keegan on 11/21/11.
//

#import <Cocoa/Cocoa.h>

#define SCKeyCmd @"cmd"
#define SCKeyOpt @"opt"
#define SCKeyCtr @"ctr"
#define SCKeyShift @"shift"

#define SCKeyEnter @"enter"
#define SCKeyDelete @"delete"

#define SCKeyUp @"up"
#define SCKeyDown @"down"
#define SCKeyLeft @"left"
#define SCKeyRight @"right"

@interface SCKeyView : NSView

- (NSArray *)keys;
- (void)setKeysWithString:(NSString *)string;
- (void)setKeysWithArray:(NSArray *)string;

@end
