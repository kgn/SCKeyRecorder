//
//  SCKey.h
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SCKey : NSObject
+ (SCKey *)key;
+ (SCKey *)keyFromString:(NSString *)string;
+ (SCKey *)keyFromCode:(unsigned short)code;
- (id)initWithString:(NSString *)string;
- (id)initWithCode:(unsigned short)code;
- (NSDictionary *)textAttributes;
- (NSDictionary *)largeTextAttributes;
- (void)drawKeyInRect:(NSRect)rect;
@property (readonly) unsigned short keyCode;
@property (readonly, getter=isModifierKey) BOOL modifierKey;
@property (readonly) NSString *stringValue;
@property (readonly) NSString *prettyStringValue;
@end

@interface SCModifierKey : SCKey
@property (readonly) NSUInteger modifierFlag;
@end
@interface SCKeyControl : SCModifierKey
@end
@interface SCKeyCommand : SCModifierKey
@end
@interface SCKeyOption : SCModifierKey
@end
@interface SCKeyShift : SCModifierKey
@end

@interface SCKeyUp : SCKey
@end
@interface SCKeyDown : SCKey
@end
@interface SCKeyLeft : SCKey
@end
@interface SCKeyRight : SCKey
@end
