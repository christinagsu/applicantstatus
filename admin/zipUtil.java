import java.io.*;
import java.util.zip.*;


public class zipUtil{

public static String compress(String str) throws IOException{
    if (str == null || str.length() == 0) {
        return str;
    }
    ByteArrayOutputStream out = null;
    GZIPOutputStream gzip = null;
	try
	{
		out = new ByteArrayOutputStream();
		gzip = new GZIPOutputStream(out);
		gzip.write(str.getBytes());
	} catch ( IOException ioExc ) {
		System.out.println ( "Exception Occured in Catch Block"+ioExc.getMessage (  )  ) ; 
	}  
	finally 
	{  
		try 
		{  
			gzip.close (  ) ; 
        }  
		catch ( IOException ioExc )  
        {  	
			System.out.println ( "Exception Occured in finally block"+ioExc.getMessage (  )  ) ; 
        }  
	}  
	return out.toString("ISO-8859-1");
}

public static String decompress(String _str) throws IOException{
    if (_str == null || _str.length() == 0) {
        return _str;
    }
    ByteArrayInputStream in = null;
    GZIPInputStream gzip = null;
	StringBuffer xmlStr = null; 
	String str = null; 
	BufferedReader zipReader = null;

	try 
	{  
		in = new ByteArrayInputStream(_str.getBytes("ISO-8859-1"));
		gzip = new GZIPInputStream(in);
		zipReader = new BufferedReader ( new InputStreamReader ( gzip )  ) ; 
		char chars [  ]  = new char [ 1024 ] ; 
		int len = 0; 
		xmlStr = new StringBuffer (  ) ; 
		//Write chunks of characters to the StringBuffer 
		while  (  ( len = zipReader.read ( chars, 0, chars.length )  )   >= 0 )   
		{  
			xmlStr.append ( chars, 0, len ) ; 
		}  
		chars = null; 
	} catch ( IOException ioExc ) {  
		System.out.println ( "Exception Occured in Catch Block"+ioExc.getMessage (  )  ) ; 
	}  
	finally 
	{  
		try 
		{  
			gzip.close (  ) ; 
			zipReader.close (  ) ; 
        }  
		catch ( IOException ioExc )  
        {  	
			System.out.println ( "Exception Occured in finally block"+ioExc.getMessage (  )  ) ; 
        }  
      }  
     return xmlStr.toString (  ) ; 
 }

 public static void main(String[] args) throws IOException {
		StringBuffer _letter = new StringBuffer (512);
		_letter.append("Congratulations! We are excited to inform you of your acceptance into Georgia State University. We look forward to welcoming you to one of the nation´s premiere urban research universities - in the heart of Atlanta - and trust that you will find a wealth of opportunity here.");
		_letter.append("Your admission is to the College of Arts & Sciences to pursue a major in Interdisciplinary Studies pending your acceptance to the Deans Office AS by audition. Please note that your acceptance is contingent upon successful completion of the college-prep curriculum and proof of graduation from high school and verification of legal presence in the United States.");
		_letter.append("Based on new University System of Georgia requirements (Policy Manual 4.1.6), students must verify their legal presence in the United States. Many students will not need to take any action as we will be able to verify the information from submission of the Free Application for Federal Student Aid (FAFSA). Information will be sent to you, both electronically and via mail, should we require additional documentation during the verification process. Your acceptance is valid for the Fall 2011 semester only;");
		String compressed = zipUtil.compress(_letter.toString());

		System.out.println("Size before compress: " + _letter.length());
		System.out.println("after compress:");
		System.out.println("Size after compression: " + compressed.length());
		System.out.println("text after compress:" + zipUtil.decompress(compressed));
				
  }
}