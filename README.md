This project is meant to be used to parse a Project Zomboid RecordedMedia file. This file contains all lines from media in game, including CDs, VHS tapes, etc.

# Requirements
To begin using the app, you must have [Python3](https://www.python.org/downloads/) installed.

# Usage
## Opening the application
In order to open and begin using the application, you need to open it using Python. On Windows, this can be done by opening the File Explorer to the project's root directory,
selecting the navigation bar and writing `cmd` in it. This will open a new command prompt window that is already positioned at the project's root directory.
Next, run the app by typing the following: `python ReadRecordedMedia.py `.

The application will prompt you for a media file to parse. As of time of writing, this media file is located in your Project Zomboid's game file directory at the path:
`...\ProjectZomboid\media\lua\shared\Translate\EN\Recorded_Media_EN.txt`. If struggling to find it, [this](https://steamcommunity.com/sharedfiles/filedetails/?id=760447682) may help.

After the application has finished, the `Output` directory in the project will be populated with all parsed media. The media will be formatted according to your defined templates.

## Templates
The `Templates` subfolder contains definitions for each media type (as defined in the .py file). By default, it should contain: CD.wikiformat, contentLine.wikiformat, Home_VHS.wikiformat, and VHS.wikiformat.

A template within the file can be defined as you might write it in the wiki. Any place that custom data should be placed can be automatically replaced utilizing `%` characters surrounding the intended replacement data.
For example, the default VHS.wikiformat looks like this: 
```
%Title%<br>
{{Transcript
|icon=vhs
|text=
%mediaContent%
}}
```
In this example, we can see two usages of this, in the first line with `%Title%` and in the second to last line with `%mediaContent%`.

There are two special replacement types, `%mediaContent%` and `%mediaContentItem%`. 
*`%mediaContent%` is used where you want to insert all lines of the media and will replace the lines with your defined template in `contentLine.wikiformat`. 
*`%mediaContentItem%` is used *only* in the `contentLine.wikiformat` and is **also** the only useable insertion tag in said file. This insertion tag will replace itself with the content of a single line.

Further, insertion tags can be defined in the Python file, as seen in the Customization section below. By default, CD has the following insertion tags: `%Title%`, `%Album%`, and `%Production%` and VHS and Home VHS have only `%Title%`.

## Simple Customization
All topics here require modifying the `ReadRecordedMedia.py` file. If you do not know programming, it may be difficult if you run into an issue - you can contact me on PZWiki [here](https://pzwiki.net/wiki/User_talk:Thing_II) if you need assistance.
### Lines to Ignore
The recorded media file has a few lines that should be ignored at the beginning. If your file appears different (due to updates, platform independent differences, etc). editing the `linesToIgnore` value to the number of blank/unnecessary lines
may cut out some garbage that appears in the output.
### Replacements
Replacements are simply found phrases within the media file that should be replaced upon first reading the file (before any parsing has taken place). By default, we do the following replacement: `"[img=music]": '♫'` which replaces all instances
of [img=music] with a music character.
### Type Values
Type values are simply the type of media and its relevant data that we are looking for. The default values looks like this:
```
typeValues = {
	"CD": ['Title', 'Album', 'Production'],
	"VHS": ['Title'],
	"Home VHS": ['Title']
}
```

Within the Recorded Media file, we see lines like this:
```
SOME_GUID1 = "CD: Hello"
SOME_GUID2 = "Hello"
SOME_GUID3 = "I say Hello"
SOME_GUID4 = "Released February 1992. Something Studio."
SOME_GUID5 = "[img=music] I said hello to you and you smiled back [img=music]"
...
```
Looking through multiple of these CDs, a pattern might appear - in this case, we see that each CD has the first line starting with `CD:`. For this reason, the key in the typeValues dictionary is set to `CD` (and the `:` is omitted).
We can also see that each CD has three lines that follow and the order appears as: Title, Album, and the Production information. Because of this, we define the values of our CD key to have `['Title', 'Album', 'Production']`, which will capture
those lines and assign them as insertion tags for all CDs. VHS and Home VHS tapes do not have this property, and instead only include the title of the VHS in the following line.
