# SCKeyRecorder

An Objective-C shortcut recorder for the Mac.

*This project is just getting started, it doesn't do much at the moment, stay tuned...*


## Current build

![Screenshot](https://github.com/InScopeApps/SCKeyRecorder/raw/master/screenshot.png)


## Mockup

![Screenshot](https://github.com/InScopeApps/SCKeyRecorder/raw/master/mockup.png)


## ARC

SCKeyRecorder works with arc and non-arc projects. If you just want to use SCKeyRecorder
you don't have to worry about how this works, just add it to your project :) If you want to contribute
to SCKeyRecorder please read this section.

SCKeyRecorder adds `arc_retain`, `arc_release`, and `arc_autorelease` to `NSObject` which should be used instead
of the standard methods. Under arc these methods will not preform any memory management, but under non-arc the
approprate `retain`, `release`, and `autorelease` will be preformed. These methods can be found in the
[NSObject+ARC.h](https://github.com/InScopeApps/SCKeyRecorder/blob/master/SCKeyRecorder/NSObject+ARC.h) category.
There is one additional item implemented as a macro for `[super dealloc]`.

    - (id)arc_retain;
    - (void)arc_release;
    - (id)arc_autorelease;
    #define ARCSuperDealloc

Some examples:

    [[[[self class] alloc] initWithCode:code] arc_autorelease];

    [[NSDictionary dictionaryWithDictionary:attributes] arc_retain];

    - (void)dealloc{
        [_stringValue arc_release];
        [_prettyStringValue arc_release];
        SCARCSuperDealloc;
    }


## Credits

- David Keegan ([@InScopeApps](https://github.com/inscopeapps))
- Indragie Karunaratne ([@indragiek](https://github.com/indragiek))


## Licence

SCKeyRecorder is avalible under the [MIT License](https://github.com/InScopeApps/SCKeyRecorder/blob/master/LICENSE).
