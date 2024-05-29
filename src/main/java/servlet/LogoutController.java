package servlet;

import object.MemberVO;
import query.MemberDAO;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/logout")
public class LogoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		MemberVO vo = (MemberVO) session.getAttribute("login");

		MemberDAO dao = MemberDAO.getInstance();
		Cookie[] cookieList = request.getCookies();
		Cookie loginCookie = null;
		for (int i = 0; i < cookieList.length; i++) {
			if (cookieList[i].getName().equals("loginCookie")) {
				loginCookie = cookieList[i];

			}
		}
		System.out.println(loginCookie);

		loginCookie.setMaxAge(0);
		loginCookie.setPath("/");
		response.addCookie(loginCookie);
		System.out.println(loginCookie);

		dao.keepLogin(vo.getUserId(), null, null);
		session.invalidate();

		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print("<script>");
		out.print("alert('로그아웃되었습니다.');");
		out.print("</script>");

		response.sendRedirect("login.jsp");
	}

}
