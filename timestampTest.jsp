<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>


<%!
	
public static void ts(JSPWriter out, String start, String stop)
{

		//String dateStart = "01/14/2012 09:29:58";
		//String dateStart = start;
		//String dateStop = "01/15/2012 10:31:48";
		//String dateStop = stop;

		//HH converts hour in 24 hours format (0-23), day calculation
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		
		java.util.Date d1 = null;
		java.util.Date d2 = null;

	try{
		

			d1 = format.parse(start);
			d2 = format.parse(stop);

			//in milliseconds
			long diff = d2.getTime() - d1.getTime();

			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000) % 24;
 			long diffDays = diff / (24 * 60 * 60 * 1000);

			String days = "";
			String hours = "";
			String minutes = "";
			String seconds = "";
			
			days = diffDays + " days, ";
			hours = diffHours + " hours, ";
			minutes = diffMinutes + " minutes, ";
			seconds = diffSeconds + " seconds.";
			
			out.println(days +  hours +  minutes +  seconds);
		} 
		
		catch (ParseException e) {
        	e.printStackTrace();
    	}


}

ts("01/14/2012 09:29:58", "01/15/2012 10:31:48");

%>


