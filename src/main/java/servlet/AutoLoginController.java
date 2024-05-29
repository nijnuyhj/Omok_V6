package servlet;

import object.MemberVO;
import query.MemberDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/autoLogin")
public class AutoLoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		process(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		process(request, response);
	}

	protected void process(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Object obj = session.getAttribute("login");
		Cookie loginCookie = null;
		MemberDAO dao = MemberDAO.getInstance();

		// 로그인된 세션이 없는 경우
		if (obj == null) {
			// 쿠키를 꺼내온다
			Cookie[] cookieList = request.getCookies();
			if (cookieList != null) {
				for (int i = 0; i < cookieList.length; i++) {
					if (cookieList[i].getName().equals("loginCookie")) {
						loginCookie = cookieList[i];
						break; // loginCookie를 찾으면 반복문 탈출
					}
				}
			}
			if (loginCookie != null) {
				String sessionId = loginCookie.getValue();
				MemberVO vo = dao.checkUserWithSessionKey(sessionId);

				if (vo != null) {
					session.setAttribute("login", vo);
					request.getRequestDispatcher("main.jsp").forward(request, response); // 자동 로그인 성공 후 메인 페이지로 이동
					return; // 메서드 종료
				}
			}
			// 자동 로그인 실패 시 로그인 페이지로 리다이렉트
			response.sendRedirect("login.jsp");
		} else {
			// 이미 로그인된 세션인 경우 메인 페이지로 이동
			request.getRequestDispatcher("main.jsp").forward(request, response);
		}
	}
}