package object;

import java.util.HashMap;
import java.util.Map;

import javax.websocket.Session;

public class MatchingUserVO {
	private static Map<Session, Session> matching = new HashMap<>();

	// 생성자 private로 선언하여 막기
	private MatchingUserVO() {
	}

	public static Map<Session, Session> getMatching() {
		return matching;
	}

}