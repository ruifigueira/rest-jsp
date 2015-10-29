<%@ include file="../includes/jackson.jspf" %>
<%@ include file="../includes/rest.jspf" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="java.util.Set" %>

<%@ page import="org.apache.log4j.Appender" %>
<%@ page import="org.apache.log4j.FileAppender" %>
<%@ page import="org.apache.log4j.Layout" %>
<%@ page import="org.apache.log4j.Level" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="org.apache.log4j.LogManager" %>
<%@ page import="org.apache.log4j.PatternLayout" %>

<%!
public static enum LevelDTO {
  OFF, ERROR, WARN, INFO, DEBUG, TRACE, ALL
}

public static class LoggerDTO {
    public String name;
    public LevelDTO level;
    public List<String> appenderNames = new ArrayList<String>();
    
    public LoggerDTO() {
    }

    public LoggerDTO(Logger logger) {
        this.name = logger.getName();
        this.level = logger.getLevel() == null ? null: LevelDTO.valueOf(logger.getLevel().toString());
        
        Enumeration enumeration = logger.getAllAppenders();
        
        while (enumeration.hasMoreElements()) {
            Appender appender = (Appender) enumeration.nextElement();
            appenderNames.add(appender.getName());
        }
    }
    
    public int hashCode() {
        return name.hashCode();
    }
    
    public boolean equals(Object obj) {
        if (obj instanceof LoggerDTO) {
            return ((LoggerDTO) obj).name.equals(name);
        }
        return false;
    }
}

public static class LayoutDTO {
    public String contentType;
    public String conversionPattern;
    
    public LayoutDTO(PatternLayout pattern) {
        contentType = pattern.getContentType();
        conversionPattern = pattern.getConversionPattern();
    }
}

public static class AppenderDTO {
    public String name;
    
    public boolean bufferedIO;
    public int bufferSize;
    public boolean append;
    public String file;
    public LayoutDTO layout;
    
    public AppenderDTO() {
    }

    public AppenderDTO(FileAppender fileAppender) {
        name = fileAppender.getName();
        bufferedIO = fileAppender.getBufferedIO();
        bufferSize = fileAppender.getBufferSize();
        append = fileAppender.getAppend();
        file = fileAppender.getFile();
        if (fileAppender.getLayout() instanceof PatternLayout) {
            layout = new LayoutDTO((PatternLayout) fileAppender.getLayout());
        }
    }
    
    public int hashCode() {
        return name.hashCode();
    }
    
    public boolean equals(Object obj) {
        if (obj instanceof AppenderDTO) {
            return ((AppenderDTO) obj).name.equals(name);
        }
        return false;
    }
}

private Map<String, Appender> getAllLog4jAppenders() {
    Map<String, Appender> appenders = new HashMap<String, Appender>();
    Enumeration enumeration = LogManager.getCurrentLoggers();
    while (enumeration.hasMoreElements()) {
        Logger logger = (Logger) enumeration.nextElement();
        for (Enumeration e = logger.getAllAppenders(); e.hasMoreElements();) {
            Appender appender = (Appender) e.nextElement();
            appenders.put(appender.getName(), appender);
        }
    }
    return appenders;
}

@RequestMapping(value = "/appenders", method = RequestMethod.GET)
@ResponseBody
public List<AppenderDTO> getAppenders() {
    List<AppenderDTO> appenders = new ArrayList<AppenderDTO>();
    for (Entry<String, Appender> entry : getAllLog4jAppenders().entrySet()) {
        if (entry.getValue() instanceof FileAppender) {
	        appenders.add(new AppenderDTO((FileAppender) entry.getValue()));
        }
    }
    return appenders;
}

@RequestMapping(value = "/levels", method = RequestMethod.GET)
@ResponseBody
public List<LevelDTO> getLevels() {
    return Arrays.asList(LevelDTO.values());
}

@RequestMapping(value = "/loggers", method = RequestMethod.GET)
@ResponseBody
public List<LoggerDTO> getLoggers() {
    Enumeration enumeration = LogManager.getCurrentLoggers();
    List<LoggerDTO> loggers = new ArrayList<LoggerDTO>();
    while (enumeration.hasMoreElements()) {
        loggers.add(new LoggerDTO((Logger) enumeration.nextElement()));
    }
    return loggers;
}

@RequestMapping(value = "/loggers/{name}", method = RequestMethod.GET)
@ResponseBody
public LoggerDTO getLogger(@PathVariable("name") String name) {
    if (LogManager.exists(name) == null) return null;
    return new LoggerDTO(Logger.getLogger(name));
}

@RequestMapping(value = "/loggers", method = RequestMethod.POST)
@ResponseBody
public LoggerDTO updateLogger(@RequestBody LoggerDTO loggerData) {
    Logger logger = Logger.getLogger(loggerData.name);
    Level level = loggerData.level == null ? null : Level.toLevel(loggerData.level.name());
    logger.setLevel(level);
    
    if (loggerData.appenderNames != null) {
        Map<String, Appender> appenders = getAllLog4jAppenders();
        
        for (String appenderName : loggerData.appenderNames) {
            Appender appender = appenders.get(appenderName);
            if (appender != null) {
                logger.addAppender(appender);
            }
        }
    }

    if (level != null) {
        logger.log(level, "Log " + logger.getName() + " set to " + level);
    }
    
    return new LoggerDTO(logger);
}
%>