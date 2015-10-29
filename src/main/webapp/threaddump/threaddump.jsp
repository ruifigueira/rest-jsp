<%@ include file="../includes/rest.jspf" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="java.util.List" %>

<%!
public static class ThreadDAO {
    public String name;
    public StackTraceElement[] stackTrace;
    
    public ThreadDAO(Thread thread, StackTraceElement[] stacktrace) {
        this.name = thread.getName();
        this.stackTrace = stacktrace;
    }
}

@RequestMapping(value = "/threads", method = RequestMethod.GET)
@ResponseBody
public List<ThreadDAO> getAllThreads() {
    List<ThreadDAO> threads = new ArrayList<ThreadDAO>();
    
    for (Entry<Thread, StackTraceElement[]> entries : Thread.getAllStackTraces().entrySet()) {
        threads.add(new ThreadDAO(entries.getKey(), entries.getValue()));
    }
    
    return threads;
}

@RequestMapping(value = "/threads/{name}", method = RequestMethod.GET)
@ResponseBody
public ThreadDAO getThread(@PathVariable("name") String name) {
    for (ThreadDAO thread : getAllThreads()) {
        if (name.equals(thread.name)) {
            return thread;
        }
    }
    return null;
}
%>