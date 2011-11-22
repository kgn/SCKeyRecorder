//
//  SCKeyView.h
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//

#import "SCKey.h"

@interface SCKeyView : NSView

- (NSString *)keysString;
- (void)setKeysWithString:(NSString *)string;
- (void)setKeysWithArray:(NSArray *)string;

@end
