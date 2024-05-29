package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import object.MemberVO;
import query.MemberDAO;
import query.RankDAO;

/**
 * Servlet implementation class WinLoseController
 */
@WebServlet("/winlosecon")
public class WinLoseController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RankDAO rdao = RankDAO.getInstance();
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		int win = Integer.parseInt(request.getParameter("win"));
		int lose = Integer.parseInt(request.getParameter("lose"));
		System.out.println("이김" + win);
		System.out.println("짐" + lose);
		String sessionid = request.getRequestedSessionId();
		HttpSession session = request.getSession();
		MemberDAO dao = MemberDAO.getInstance();
//		MemberVO vo = (MemberVO) session.getAttribute("login");
		MemberVO vo = dao.checkUserWithSessionKey(sessionid);
		String ddd = (String) session.getAttribute("userId");

		if (win == 1 && lose == 0) {
			rdao.updateWINRATE(vo.getUserId());
		} else if (win == 0 && lose == 1) {
			rdao.updateLOSERATE(vo.getUserId());
		}

	}

}
