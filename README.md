# arbitrary-rainbow
Random code that doesn't fit somewhere else.

Goals:

1. Code will be drop-in friendly. If it is NOT drop-in friendly, that will be because it's in-development and it will be marked as such.
2. Dependencies will be clearly listed at the top of the file. This includes any functions not built by default within TinyMUX.
3. Purpose of the file will be clearly described unless the work is in progress.
4. Once complete, a help file will be included at the top of the file, in block comments, ready to be dropped into a wiki.
5. Comments permitted are @@, @@(), and /**/. Anything else is a nope. Inline comments must be at the beginning of the line and will reference the item below.
6. Block comments are only allowed at the beginning and end of the file so that they can be easily skipped by a user mousing through the file.
7. If a preprocessor is necessary, it will be the "mucode preprocessor" included in this repository. Drop the code in there, hit the "Format code for MU*" button, and all comments will be stripped out. Report any warnings found for code in this repo as tickets for that preprocessor.
8. Testing code will be present only on in-development code and will be wrapped in block comments so that it can be stripped by a preprocessor.
9. Pull requests are allowed but must be in a clearly-named branch subbed off of either feature/ or bug/. Commits must be incremental and clear.
10. Spacing will be ruthlessly fixed to obey the rules - no spacing at the end of a line, no indents, no unexpected line breaks, and put spaces in the inline code so it's readable.
11. Documentation will be as close to the item to be changed as possible - function parameters above the functions, etc.
12. Any non-drop-in code will be commented out and called out at the top of the file.
