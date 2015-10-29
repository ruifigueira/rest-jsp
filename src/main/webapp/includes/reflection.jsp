<%@ page language="java" trimDirectiveWhitespaces="true"  contentType="text/html; charset=UTF-8" errorPage="error.jspf" %>

<%@ page import="java.lang.reflect.Field" %>

<%!
public static class ReflectionUtils {
    
    public static <T> T getFieldOrNull(Object obj, String fieldName) {
        try {
	        Field field = obj.getClass().getField(fieldName);
	        field.setAccessible(true);
	        return (T) field.get(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
%>