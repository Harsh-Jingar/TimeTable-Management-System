package AppContextListener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialization logic (if needed)
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Stop MySQL's abandoned connection cleanup thread when the app stops
        AbandonedConnectionCleanupThread.uncheckedShutdown();
    }
}
