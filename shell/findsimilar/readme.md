# findsimilar

Using the [whoosh python library](https://pythonhosted.org/Whoosh/intro.html), this script indexes and then give the ability to find similar text documents.

![](http://i.imgur.com/LXUs3VB.png)

## Requirements
Requires python and whoosh. To install whoosh use:

	$ pip install whoosh

	
## Preliminary structures
### Notes directory structure
The script accepts the following note directory structure:

	$ tree -a -L 1
	.
	├── .index
	├── archive
	├── findsimilar.py

All of the notes are contained within the `archive` directory. Note that the directory `.index` is created by the script if it does not exist.

### Notes form
My notes are structured in the following form:

	A reinforcing feedback loop creates more input to a stock the more that is already within it. It enhances whatever direction of change is imposed on it.
	
	For example population growth, company profits, pollution etc..
	
	They exist when a system element has the ability to reproduce itself or to grow at a constant fraction of itself.
	
	----
	
	{Meadows2008t}
	{1502141701}
	
	@systems-theory
	@feedback-loops

The content of the note is all text above the markdown horizontal break syntax `----`. Below this are the metadata-links to references, links to UIDs of other notes and tags, prepended with `@`. The scripts currently do not take into account anything below the horizontal break.

## Usage
**Note**: The script has only been tested using a notes directory structure similar to that shown in the section `Notes directory structure`.

There are three variables at the top of script to be set.

- `notesDir` - Set this to the directory that your notes are contained in.
- `notesFileExtension` - Set this to a specific filetype for your notes. Default is `md`
- `indexDir` - That folder will be created relative to where the script is located and contains all of the indexed data of the notes.

Once this has all been set and configured, enter the directory that the script is in and run the following

	$ python createindex.py
	
Now, using the following you can find which notes contain similar _rare_ words

	$ python findsimilar.py <note path>
	
for example:

	$ python findsimilar.py search "archive/1502141701 Balancing feedback loops in systems.md"