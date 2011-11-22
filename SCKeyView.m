//
//  SCKeyView.m
//  SCKeyRecorderSample
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

- (NSArray *)keys{
    return [[_keys copy] autorelease];
}

- (void)setKeysWithArray:(NSArray *)keys{
    NSMutableArray *mkeys = [[NSMutableArray alloc] init];
    for(NSString *key in keys){
        if(key == nil){
            continue;
        }else if([key isEqualToString:@"command"]){
            key = SCKeyCmd;
        }else if([key isEqualToString:@"option"] ||
                 [key isEqualToString:@"alt"]){
            key = SCKeyOpt;
        }else if([key isEqualToString:@"control"] || 
                 [key isEqualToString:@"ctrl"]){
            key = SCKeyCtr;
        }
        [mkeys addObject:key];
    }
    
    // Put the modifier keys at the front and sort everything else alphabetically
    _keys = [[mkeys sortedArrayUsingComparator:^(NSString *key1, NSString *key2){
        static NSSet *frontKeys = nil;
        if(frontKeys == nil){
            frontKeys = [NSSet setWithObjects:SCKeyCmd, SCKeyOpt, SCKeyCtr, SCKeyShift, nil];
        }
        
        if([frontKeys containsObject:key1] && ![frontKeys containsObject:key2]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if(![frontKeys containsObject:key1] && [frontKeys containsObject:key2]){
            return (NSComparisonResult)NSOrderedDescending;
        }      
        
        return [key1 localizedCaseInsensitiveCompare:key2];
    }] retain];
    
    [mkeys release];
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect{
    static NSDictionary *textAttributes = nil;
    if(textAttributes == nil){
        NSShadow *textShadow = [[NSShadow alloc] init];
        [textShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.6f]];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
        [attributes setObject:[NSFont systemFontOfSize:11.0f] forKey:NSFontAttributeName];
        [attributes setObject:textShadow forKey:NSShadowAttributeName];
        textAttributes = [[NSDictionary dictionaryWithDictionary:attributes] retain];
        [textShadow release];
    }

    NSRect boundsRect = NSInsetRect(self.bounds, 1.5f, 1.5f);
    [[NSColor grayColor] setStroke];    
    [[NSColor lightGrayColor] setFill];
    NSBezierPath *boundsPath = [NSBezierPath bezierPathWithRoundedRect:boundsRect xRadius:5.0f yRadius:5.0f];
    [boundsPath stroke];
    [boundsPath fill];
    
    NSRect keyRect = NSInsetRect(self.bounds, 5.5f, 5.5f);
    keyRect.size.width = 80.0f;
    for(NSString *key in _keys){
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
        
        NSRect stringRect = keyOffsetRect;
        stringRect.size = [key sizeWithAttributes:textAttributes];
        stringRect.origin.y += 3.0f;
        stringRect.origin.x += 6.0f;
        NSAttributedString *attributedString = 
        [[NSAttributedString alloc] initWithString:key attributes:textAttributes];
        [attributedString drawInRect:stringRect];

        keyRect.origin.x += keyRect.size.width+5.0f;
    }
}

@end
