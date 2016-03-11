<cffunction name="GetPDFInfo" returntype="struct" access="public" output="no">
    <cfargument name="PDFFile" type="string" required="yes">

    <cfscript>
    // Init all vars

    var formIS="";
    var PDFfactory="";
    var PDFdoc="";
    var formType="";
    var attachments="";
    var result=StructNew();

    // PDF form input stream

    formIS=CreateObject("java", "java.io.FileInputStream");
    formIS.init(ARGUMENTS.PDFFile);

    // Get PDF document object

    PDFfactory=CreateObject("java", "com.adobe.pdf.PDFFactory");
    PDFdoc=PDFfactory.openDocument(formIS);

    // Get page count and version

    result.pages=PDFdoc.getNumberOfPages();
    result.version=PDFdoc.getVersion();

    // Get formtype object

    formType=PDFdoc.getFormType();    

    // Determine type

    if ((formType EQ FormType.XML_FORM)
        OR (FormType EQ FormType.ACROFORM))
        result.isform=TRUE;
    else
        result.isform=FALSE;

    // Get attachments

    attachments=PDFdoc.getFileAttachmentNames();
    // If have any, get count

    if (IsDefined("attachments") AND IsArray(attachments))
        result.attachments=ArrayLen(attachments);
    else
        result.attachments=0;
    </cfscript>

    <cfreturn result>
</cffunction>

<cfset PDFFile=ExpandPath("prevLetter.pdf")>
<cfdump var="#GetPDFInfo(PDFFile)#">
