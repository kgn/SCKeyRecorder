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

SCKeyRecorder uses macros to add the retains and releases in the preprocessor phase based on the
value of `__has_feature(objc_arc)`. These macros can be found in
[SCARC.h](https://github.com/InScopeApps/SCKeyRecorder/blob/master/SCKeyRecorder/SCARC.h).

    SCARCRetain(obj)
    SCARCRelease(obj)
    SCARCAutoRelease(obj)
    SCARCSuperDealloc

Use these macros insead of the standard `[NSObject retain]`, `[NSObject release]`.
These macros will wrap the object in retain and release only if arc is not being used.

    SCARCAutoRelease([[[self class] alloc] initWithCode:code]);

    SCARCRetain([NSDictionary dictionaryWithDictionary:attributes]);

    - (void)dealloc{
        SCARCRelease(_stringValue);
        SCARCRelease(_prettyStringValue);
        SCARCSuperDealloc;
    }


## Credits

- David Keegan ([@InScopeApps](https://github.com/inscopeapps))
- Indragie Karunaratne ([@indragiek](https://github.com/indragiek))


## Licence

SCKeyRecorder is avalible under the [MIT License](https://github.com/InScopeApps/SCKeyRecorder/blob/master/LICENSE).
