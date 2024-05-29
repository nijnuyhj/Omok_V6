package query;

import object.RankVO;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class RankDAO {
	private static RankDAO instance;
	private PreparedStatement pstmt;
	private DataSource dataFactory;
	private Connection con;

	private RankDAO() {
		try {
			Context ctx = new InitialContext();
			// JNDI에 접근하기 위해 기본경로를 지정
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			// context.xml 에서 설정한 name값으로 톰캣에 미리 연결한 DataSource 받아오기
			dataFactory = (DataSource) envContext.lookup("jdbc/mysql");
			// System.out.println("접속 성공");
			ctx.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static synchronized RankDAO getInstance() {
		if (instance == null) {
			instance = new RankDAO();
		}
		return instance;
	}

	// rate of win top10
	public List<RankVO> listWinRate() {
		List<RankVO> list = new ArrayList<>();
		ResultSet rs = null;
		try {
			con = dataFactory.getConnection();
			String query = "select rank() over (order by win_rate desc) as ranking, user_id, user_nickname, win_rate ";
			query += "from (select * , round(ifnull(win/(win+lose)*100, 0),1) as win_rate from user) as a ";
			query += "limit 10";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery(query);
			while (rs.next()) {
				String userId = rs.getString("user_id");
				String userNickname = rs.getString("user_nickname");
				double point = rs.getDouble("win_rate");
				RankVO vo = new RankVO();
				int rank = rs.getInt("ranking");
				vo.setRank(rank);
				vo.setUserId(userId);
				vo.setUserNickname(userNickname);
				vo.setPoint(point);
				list.add(vo);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				rs.close();
			} catch (Exception e) {
			}
			try {
				pstmt.close();
			} catch (Exception e) {
			}
			try {
				con.close();
			} catch (Exception e) {
			}
		}
		return list;
	}

	// count of wins top10
	public List<RankVO> listWinCount() {
		List<RankVO> list = new ArrayList<>();
		ResultSet rs = null;
		try {
			con = dataFactory.getConnection();
			String query = "select rank() over (order by win desc) as ranking, user_id, user_nickname, win ";
			query += "from user limit 10";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery(query);
			while (rs.next()) {
				int rank = rs.getInt("ranking");
				String userId = rs.getString("user_id");
				String userNickname = rs.getString("user_nickname");
				double point = rs.getDouble("win");
				RankVO vo = new RankVO();
				vo.setRank(rank);
				vo.setUserId(userId);
				vo.setUserNickname(userNickname);
				vo.setPoint(point);
				list.add(vo);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				rs.close();
			} catch (Exception e) {
			}
			try {
				pstmt.close();
			} catch (Exception e) {
			}
			try {
				con.close();
			} catch (Exception e) {
			}
		}
		return list;
	}
	public void updateWINRATE (String id) {
		try {
			con = dataFactory.getConnection();
			String query = "update user set win = win +1 where User_id=?";

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				pstmt.close();
			} catch (Exception e) {
			}
			try {
				con.close();
			} catch (Exception e) {
			}
		}
		}
	public void updateLOSERATE (String id) {
		try {
			con = dataFactory.getConnection();
			String query = "update user set lose = lose +1 where User_id=?";

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				pstmt.close();
			} catch (Exception e) {
			}
			try {
				con.close();
			} catch (Exception e) {
			}
		}
		}
}

