//
//  SCKey.h
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//

#import <Cocoa/Cocoa.h>

@interface SCKey : NSObject
+ (SCKey *)key;
+ (SCKey *)keyFromString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (BOOL)isModifierKey;
- (NSString *)stringValue;
- (NSString *)prettyStringValue;
- (NSDictionary *)textAttributes;
- (NSDictionary *)largeTextAttributes;
- (void)drawKeyInRect:(NSRect)rect;
@end

@interface SCModifierKey : SCKey
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
