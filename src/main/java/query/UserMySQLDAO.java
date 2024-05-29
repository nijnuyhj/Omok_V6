package query;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import object.MemberVO;

public class UserMySQLDAO implements UserDAO {
	private static UserMySQLDAO instance;
	private Connection con;
	private PreparedStatement pstmt;
	private DataSource dataFactory;

	private UserMySQLDAO() {
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jdbc/mysql");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static synchronized UserMySQLDAO getInstance() {
		if (instance == null) {
			instance = new UserMySQLDAO();
		}
		return instance;
	}

	@Override
	public boolean registerUser(MemberVO user) {
		int result = 0;
		try {
			con = dataFactory.getConnection();
			pstmt = con.prepareStatement("INSERT INTO USER VALUES (?, ?, ?, 0, 0, null, null)");
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getUserPw());
			pstmt.setString(3, user.getUserNickname());
			result = pstmt.executeUpdate();
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				pstmt.close();
				con.close();
			} catch (Exception e) {
			}
		}
		if (result >= 1) {
			return true;
		}
		return false;
	}
}
