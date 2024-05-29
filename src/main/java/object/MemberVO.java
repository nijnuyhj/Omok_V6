package object;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberVO {

	private String userId;
	private String userPw;
	private String userNickname;
	private int win;
	private int lose;

}