package object;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
public class RankVO {
	private int rank;
	private String userId;
	private String userNickname;
	private double point; // 승률 또는 승 횟수 
	
//	public int getRank() {
//		return rank;
//	}
//	public void setRank(int rank) {
//		this.rank = rank;
//	}
//	public String getUserId() {
//		return userId;
//	}
//	public void setUserId(String userId) {
//		this.userId = userId;
//	}
//	public String getUserNickname() {
//		return userNickname;
//	}
//	public void setUserNickname(String userNickname) {
//		this.userNickname = userNickname;
//	}
//	public double getPoint() {
//		return point;
//	}
//	public void setPoint(double point) {
//		this.point = point;
//	}
}
