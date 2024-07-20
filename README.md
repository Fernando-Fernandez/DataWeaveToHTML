# DataWeaveToHTML

# A Non-conventional use of DataWeave

DataWeave makes data transformation easier to code, more scalable, and efficient. 

You can create DataWeave scripts as metadata and invoke them from Apex (and consequently, from flows).

The major benefit is that it frees us up from having to dive too deeply in details to handle different file formats.

The major file formats it can handle are:  

CSV

Java object

JSON

XML

In this quick proof-of-concept, I am converting a JSON response from a currency rate web service into a HTML Table to be displayed on a rich text field.

But there is no "official" HTML format available in DataWeave!
Right, but you can use XML and specify "writeDeclaration=false" to get the same effect.

Please see the rest of the article at my LinkedIn profile.
