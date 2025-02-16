
import com.timetable.dao.TimeTableDAO;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/HandleSpecialActionsServlet")
public class HandleSpecialActionsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cancelClass = request.getParameter("cancel_class");
        String rescheduleClass = request.getParameter("reschedule_class");

        TimeTableDAO timetableDAO = new TimeTableDAO();

        if (cancelClass != null && !cancelClass.isEmpty()) {
            boolean success = false;
            try {
                success = timetableDAO.cancelClass(Integer.parseInt(cancelClass));
            } catch (SQLException ex) {
                Logger.getLogger(HandleSpecialActionsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (success) {
                response.sendRedirect("timetableManage.jsp?status=cancelled");
            } else {
                response.sendRedirect("errorPage.jsp");
            }
        } else if (rescheduleClass != null && !rescheduleClass.isEmpty()) {
            boolean success = false;
            try {
                success = timetableDAO.rescheduleClass(rescheduleClass, Integer.parseInt(rescheduleClass.split(",")[0]));
            } catch (SQLException ex) {
                Logger.getLogger(HandleSpecialActionsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (success) {
                response.sendRedirect("timetableManage.jsp?status=rescheduled");
            } else {
                response.sendRedirect("errorPage.jsp");
            }
        }
    }
}
