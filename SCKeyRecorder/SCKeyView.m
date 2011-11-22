//
//  SCKeyView.m
//  SCKeyRecorder
//
//  Created by David Keegan on 11/21/11.
//

#import "SCKeyView.h"

@implementation SCKeyView{
    NSArray *_keys;
}

- (id)initWithFrame:(NSRect)frame{
    if((self = [super initWithFrame:frame])){
        _keys = [[NSArray alloc] init];
    }
    return self;
}

- (void)setKeysWithString:(NSString *)keys{
    [self setKeysWithArray:[keys componentsSeparatedByString:@"+"]];
}

- (NSString *)keys{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[_keys count]];
    for(SCKey *key in _keys){
        [keys addObject:[key stringValue]];
    }
    return [keys componentsJoinedByString:@"+"];
}

- (void)setKeysWithArray:(NSArray *)keys{
    NSMutableArray *mkeys = [[NSMutableArray alloc] init];
    for(id key in keys){
        if([key isKindOfClass:[SCKey class]]){
            [mkeys addObject:key];
        }else if([key isKindOfClass:[NSString class]]){
            SCKey *newKey = [SCKey keyFromString:(NSString *)key];
            [mkeys addObject:newKey];
        }else{
            NSLog(@"Unknown key: %@", key);
        }
    }
    
    // Put the modifier keys at the front and sort everything else alphabetically
    _keys = [[mkeys sortedArrayUsingComparator:^(SCKey *key1, SCKey *key2){
        if([key1 isModifierKey] && ![key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if(![key1 isModifierKey] && [key2 isModifierKey]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return [[key1 stringValue] localizedCaseInsensitiveCompare:[key2 stringValue]];
    }] retain];
    
    [mkeys release];
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect{
    NSRect boundsRect = NSInsetRect(self.bounds, 1.5f, 1.5f);
    [[NSColor grayColor] setStroke];
    [[NSColor lightGrayColor] setFill];
    NSBezierPath *boundsPath = [NSBezierPath bezierPathWithRoundedRect:boundsRect xRadius:5.0f yRadius:5.0f];
    [boundsPath stroke];
    [boundsPath fill];
    
    NSRect keyRect = NSInsetRect(self.bounds, 5.5f, 5.5f);
    for(SCKey *key in _keys){
        keyRect.size.width = [key isModifierKey] ? 80.0f : 60.0f;
        NSRect keyOffsetRect = keyRect;
        [[NSColor darkGrayColor] setStroke];
        [[NSColor darkGrayColor] setFill];
        NSBezierPath *underKeyPath = [NSBezierPath bezierPathWithRoundedRect:keyOffsetRect xRadius:3.0f yRadius:3.0f];
        [underKeyPath stroke];
        [underKeyPath fill];
        
        keyOffsetRect.origin.y += 3.0f;        
        keyOffsetRect.size.height -= 3.0f;
        [[NSColor darkGrayColor] setStroke];  
        [[NSColor colorWithDeviceWhite:0.9f alpha:1.0f] setFill];
        NSBezierPath *keyPath = [NSBezierPath bezierPathWithRoundedRect:keyOffsetRect xRadius:3.0f yRadius:3.0f];
        [keyPath stroke];
        [keyPath fill];
        
        [key drawKeyInRect:keyOffsetRect];

        keyRect.origin.x += keyRect.size.width+5.0f;
    }
}

@end
