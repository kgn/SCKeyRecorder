# SCKeyRecorder

An Objective-C shortcut recorder for the Mac.

*This project is just getting started, it doesn't do much at the moment, stay tuned...*


## Current build

![Screenshot](https://github.com/InScopeApps/SCKeyRecorder/raw/master/screenshot.png)


## Mockup

![Screenshot](https://github.com/InScopeApps/SCKeyRecorder/raw/master/mockup.png)


## ARC

SCKeyRecorder works with arc and non-arc projects. If you just want to use SCKeyRecorder
you don't have to worry about this, just add it to your project. If you want to contribute
to SCKeyRecorder please read this section.

SCKeyRecorder uses macros to add the retains and releases in the preprocessor phase based on the
`__has_feature(objc_arc)` macro. These macros can be found in the
[SCARC.h](https://github.com/InScopeApps/SCKeyRecorder/raw/master/SCKeyRecorder/SCARC.h) file.
This file contains macros related to retaining and releasing objects.

    #define SCARCRetain(obj)
    #define SCARCRelease(obj)
    #define SCARCAutoRelease(obj)
    #define SCARCSuperDealloc

Use these macros insead of the standard `[NSObject retain]`, `[NSObject release]`.
These macros will wrap the object in retain and release if arc is not being used,
and they are essentially a no-op if arc is being used.

    SCARCAutoRelease([[[self class] alloc] initWithCode:code]);

    SCARCRetain([NSDictionary dictionaryWithDictionary:attributes]);

    SCARCRelease(attributedString);


## Credits

- David Keegan ([@InScopeApps](https://github.com/inscopeapps))
- Indragie Karunaratne ([@indragiek](https://github.com/indragiek))
