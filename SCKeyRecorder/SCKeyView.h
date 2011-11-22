//
//  SCKeyView.h
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "SCKey.h"

@interface SCKeyView : NSView

- (NSString *)keysString;
- (void)setKeysWithString:(NSString *)string;
- (void)setKeysWithArray:(NSArray *)string;

- (void)setKeysFromStandardUserDefaultForKey:(NSString *)key;
- (void)storeKeysInStandardUserDefaultForKey:(NSString *)key;

@end
