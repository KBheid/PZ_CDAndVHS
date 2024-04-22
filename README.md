This project is meant to be used to parse a Project Zomboid RecordedMedia file. This file contains all lines from media in game, including CDs, VHS tapes, etc.

# Requirements
To begin using the app, you must have [Python3](https://www.python.org/downloads/) installed.
Further, in order to parse PZ's lua files, you will need to have a Lua interpreter installed. One can be found [here](https://github.com/rjpcomputing/luaforwindows).

# Usage
## Opening the application
To run the application, simply run the included `run.bat` batch script if on Windows. 
The batch file will prompt you for a path to your Project Zomboid install directory. If struggling to find it, [this](https://steamcommunity.com/sharedfiles/filedetails/?id=760447682) may help.


If not on Windows, you will need to run the lua and python scripts yourself.

`ParseAndSaveMedia.lua` expects two command line arguments:
* A path to the project zomboid directory.
* A path to the current working directory (for this repository).

`ReadRecordedMedia.py` expects a single command line argument:
* A path to the project zomboid directory.



After the application has finished, the `Output` directory in the project will be populated with all parsed media. The media will be formatted according to your defined templates.

## Templates
The `Templates` subfolder contains definitions for each media type (as defined in the .py file). By default, it should contain: CDs.wikiformat, contentLine.wikiformat, Home-VHS.wikiformat, Retail-VHS.wikiformat, and VHS.wikiformat.

A template within the file can be defined as you might write it in the wiki. Any place that custom data should be placed can be automatically replaced utilizing `%` characters surrounding the intended replacement data.
For example, the default VHS.wikiformat looks like this: 
```
%title%<br>
%if%%subtitle%<br>
%if%%extra%<br>
{{Transcript
|icon=vhs
|text=
%mediaContent%
}}
```
In this example, we can see two usages of this, in the first line with `%title%` and in the second to last line with `%mediaContent%`.

There are three special replacement types, `%mediaContent%`, `%mediaContentItem%`, and `%if%`. 
*`%mediaContent%` is used where you want to insert all lines of the media and will replace the lines with your defined template in `contentLine.wikiformat`. 
*`%mediaContentItem%` is used *only* in the `contentLine.wikiformat`. This insertion tag will replace itself with the content of a single line.
*`%if%` is the only non-insertion tag. This tag instead *removes* the line it is present on if an insertion tag in the same line fails to find a result. The tag is consumed in the process.

Further, insertion tags can be defined in the Python file, as seen in the Customization section below. These tags will only be usable if they match with values found in Recorded Media definitions found at `.../ProjectZomboid/media/lua/shared/RecordedMedia/recorded_media.lua`. By default, the following tags exist:
*`%itemDisplayName%`: The display name of the item, as found in game (always available).
*`%id%`: The media id (always available).
*`%category%`: The category of media: `CDs`, `Home-VHS`, `Retail-VHS`, or `VHS` (always available).
*`%subtitle%`: The media's subtitle (optional).
*`%author%`: The media's author (optional).
*`%extra%`: Extra information, for CDs often Production information (optional).
*`%spawning%`: ??? (always available)

Lastly, within `contentLine.wikiformat`, four additional tags are present and always available.
*`%r%`: The red value for the text color.
*`%g%`: The green value for the text color.
*`%b%`: The blue value for the text color.
*`%codes%`: The codes to apply stat changes (including skill xp). 

## Simple Customization
All topics here require modifying the `ReadRecordedMedia.py` file. If you do not know programming, it may be difficult if you run into an issue - you can contact me on PZWiki [here](https://pzwiki.net/wiki/User_talk:Thing_II) if you need assistance.
### Lines to Ignore
The recorded media file has a few lines that should be ignored at the beginning. If your file appears different (due to updates, platform independent differences, etc). editing the `linesToIgnore` value to the number of blank/unnecessary lines
may cut out some garbage that appears in the output.
### Replacements
Replacements are simply found phrases within the media file that should be replaced upon first reading the file (before any parsing has taken place). By default, we do the following replacement: `"[img=music]": '♫'` which replaces all instances
of [img=music] with a music character.
### Media Types
Media types are the type of medias that are explored and parsed. This list *must* contain all `category`s found in `recorded_media.lua`.
```
mediaTypes = [
	"CDs",
	"VHS",
	"Home-VHS",
	"Retail-VHS"
]
```
### Value Names
Value Names are simply the data that you want to extract from `.../ProjectZomboid/media/lua/shared/RecordedMedia/recorded_media.lua`. The second item in the tuple is whether or not the value should utilize the Translation data (ie. if it appears as a GUID). The default values are:
```
valueNames = [
	('title', True),
	('extra', True),
	('author', True),
	('subtitle', True),
	('itemDisplayName', True),
	('spawning', False),
	('category', False)
]
```

Within the Recorded Media lua file, we see lines like this:
```
-- Media: CD: The Big Example [id: 81352bbd-0124-66b8-8745-6ff316aabc35]
RecMedia["81352bbd-0124-66b8-8745-6ff316aabc35"] = {
	itemDisplayName = "SOME_GUID",
	title = "SOME_GUID",
	subtitle = nil,
	author = "SOME_GUID",
	extra = "SOME_GUID",
	spawning = 0,
	category = "CDs",
	lines = {
		{ text = "SOME_GUID", r = 1.00, g = 0.00, b = 0.00, codes = "BOR-1" },
		...
	},
};
```
Value Names can only be items that appear on the left side of an `=` operator, excluding `lines`.
