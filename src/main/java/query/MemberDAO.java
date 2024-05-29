
package query;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import object.MemberVO;

public class MemberDAO {
	private static MemberDAO instance;
	private PreparedStatement pstmt;
	private DataSource dataFactory;
	private Connection con;

	private MemberDAO() {
		try {
			Context ctx = new InitialContext();
			// JNDI에 접근하기 위해 기본경로를 지정
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			// context.xml 에서 설정한 name값으로 톰캣에 미리 연결한 DataSource 받아오기
			dataFactory = (DataSource) envContext.lookup("jdbc/mysql");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static synchronized MemberDAO getInstance() {
		if (instance == null) {
			instance = new MemberDAO();
		}
		return instance;
	}

	public MemberVO login(MemberVO memberVO) {
		MemberVO vo = null;
		String id = memberVO.getUserId();
		String pwd = memberVO.getUserPw();
		try {
			con = dataFactory.getConnection();
			String query = "select * from user where User_id=? and User_pw=?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pwd);

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new MemberVO();

				vo.setUserId(rs.getString("User_id"));
				vo.setUserPw(rs.getString("User_pw"));

			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				closeResource();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return vo;
	}

	// 세션 아이디 db 저장
	public void keepLogin(String id, String sessionId, Date next) {
		try {
			con = dataFactory.getConnection();
			String query = "update user set sessionKey = ?, sessionLimit = ? where User_id=?";

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, sessionId);
			pstmt.setDate(2, next);
			pstmt.setString(3, id);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				closeResource();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

	}

	// 쿠키 만료시간 전이면 MemberVO 객체 출력
	public MemberVO checkUserWithSessionKey(String sessionId) {
		MemberVO vo = null;
		try {
			con = dataFactory.getConnection();
			String query = "select * from user where sessionKey = ? and sessionLimit > now()";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, sessionId);

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new MemberVO();

				vo.setUserId(rs.getString("User_id"));
				vo.setUserPw(rs.getString("User_pw"));

			}

		} catch (Exception e) {
			e.printStackTrace();

		}finally {
			try {
				closeResource();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return vo;
	}
	
	public void closeResource() throws SQLException {
		pstmt.close();
		con.close();
	}

}
