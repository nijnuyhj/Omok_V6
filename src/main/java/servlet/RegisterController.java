package servlet;

import object.MemberVO;
import query.UserDAO;
import query.UserMySQLDAO;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/register")
public class RegisterController extends HttpServlet {
	UserDAO dao = UserMySQLDAO.getInstance();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/register.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String nickname = request.getParameter("nickname");

		System.out.println(id);
		System.out.println(pw);
		System.out.println(nickname);

		MemberVO vo = new MemberVO();
		vo.setUserId(id);
		vo.setUserPw(pw);
		vo.setUserNickname(nickname);
		boolean status = dao.registerUser(vo);
		

		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		if (status) {
			out.print("true");
		} else {
			out.print("false");
		}
	}

}
