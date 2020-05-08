from whoosh.index import open_dir
from whoosh.index import create_in
from whoosh.fields import *
from whoosh.qparser import QueryParser
import glob
import os


# USER SET PARAMETERS ############

notesDir =              "../zettel"   # set this to the (relative to the script) folder that contains your notes.
notesFileExtension =    "md"        # set this to the file extension of the notes you want to query (txt, md, markdown etc.)
indexDir =              ".index"    # whoosh index folder

##################################


def createIndex():
    """ Create index for whoosh to be able to query """
    if not os.path.exists(indexDir):
        os.makedirs(indexDir)

    schema = Schema(title=TEXT(stored=True), 
                    path=ID(stored=True), 
                    content=TEXT(stored=True))

    ix = create_in(".index", schema)
    writer = ix.writer()

    for filename in glob.glob(notesDir + '/*.' + notesFileExtension):
        noteContent = ""
        with open(filename, 'r') as myfile:
            for line in myfile:
                if '----' not in line:
                    if line[0][0] is not '!':
                        noteContent += line
                else:
                    break

        writer.add_document(title=  unicode(os.path.basename(filename), 'utf-8'),
                            path=   unicode(filename, 'utf-8'),
                            content=unicode(noteContent, 'utf-8'))

    writer.commit()
    print "index created"


def searchSimilar(fullfilename):
    """ Search for similar documents using a document pathname that
        has already been indexed. 
    """
    ix = open_dir(indexDir)

    with ix.searcher() as searcher:
        filename = os.path.basename(fullfilename)
        
        docnum = searcher.document_number(path=unicode(fullfilename, 'utf-8'))
        if docnum is None:
            print "That document has not been indexed"
        else:
            r = searcher.more_like(docnum, 'content', numterms=20)
            if len(r) > 1:
                header = "Similar files to '" + filename.replace(".md", "") + "'"
                print "\n" + header + "\n" + "-"*len(header) + "\n"
                for hit in r:
                    print hit['title'].replace(".md","")
                    print " score: " + str(hit.score) + "\n"

            print "keywords: " + ", ".join(zip(*r.key_terms('content'))[0])


def printUsage():
    print "usage:"
    print " python findsimilar.py createindex"
    print " python findsimilar.py search <filepath>"


def main():
    if sys.argv[1] == 'createindex':
        createIndex()
    elif sys.argv[1] == 'search':
        if sys.argv[2]:
            searchSimilar(sys.argv[2])
        else:
            printUsage()
            exit()
    else: 
        printUsage()
        exit()


if __name__ == "__main__":
    main()
