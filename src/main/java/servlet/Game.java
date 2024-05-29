package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.json.JSONObject;

import object.MatchingUserVO;

@ServerEndpoint("/omok")
public class Game {
	private static Map<Session, String> clients = new HashMap<>();
	private static Queue<Session> waitSession = new LinkedList<>();
	private static Map<Session, Session> matching = MatchingUserVO.getMatching();

	@OnOpen
	public void onOpen(Session sessionA) {
		if (waitSession.isEmpty()) {
			// 대기중인 세션 없으면 waitSession에 추가
			waitSession.add(sessionA);
			System.out.println("대기중인 세션 " + waitSession.size() + "개");
		} else {
			// 대기중인 세션이 있으면 waitSession에서 꺼내온 짝꿍 Session과 매칭(matching 맵에 넣기)
			System.out.println("대기중인 세션: " + waitSession.size() + "개, 매칭 시도");
			Session sessionB = waitSession.poll();

			matching.put(sessionB, sessionA);
			matching.put(sessionA, sessionB);
			clients.put(sessionA, sessionA.getId());
			clients.put(sessionB, sessionB.getId());

			int playerNumberA = 2; // 매칭 시도한 playerNumber는 2
			int playerNumberB = 1; // 먼저 대기중이었던 playerNumber는 1
			try {
				// 매칭 성공한 짝꿍 세션들에게 playerNumber 전달
				sessionA.getBasicRemote()
						.sendText("{\"type\": \"playerNumber\", \"playerNumber\": " + playerNumberA + "}");
				sessionB.getBasicRemote()
						.sendText("{\"type\": \"playerNumber\", \"playerNumber\": " + playerNumberB + "} ");
				
				//매칭 상태 보내기
				sessionA.getBasicRemote()
						.sendText("{\"type\":\"matchingStatus\",\"matchingStatus\":true}");
				sessionB.getBasicRemote()
						.sendText("{\"type\":\"matchingStatus\",\"matchingStatus\":true}");
				
				
				//sessionA 두번쨰로 들어온놈  sessionB 첫번쨰로 들어온놈
				System.out.println("세션" + sessionA.getId() + "와 세션" + sessionB.getId() + " 매칭 성공");  
				System.out.println("진행중인 게임 : "+matching.size());
			} catch (IOException e) {
				e.printStackTrace();
			}

		}

	}

	@OnMessage
	public void handleMessage(String message, Session session) {
		try {
			if(message.contains("disconnect")) { // 연결이 끊어졌을 경우
				session.getBasicRemote().sendText(message); //  {type : "disconnect"} 메시지 보내기 
				return;
			}
			
			int winner = (Integer)new JSONObject(message).get("winner");
			
			
			if(winner!=0) {
				matching.get(session).getBasicRemote().sendText(message);
				
				//승자 구분
				session.getBasicRemote()
				.sendText("{\"type\": \"winner\", \"playerNumber\": "+winner+"}");
				matching.get(session).getBasicRemote()
				.sendText("{\"type\": \"winner\", \"playerNumber\": "+winner+"}");
				
			}else {
				// (matching 맵에서 짝꿍 세션을 꺼내) 나의 짝꿍 Session에게만 message 전송
				matching.get(session).getBasicRemote().sendText(message);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	@OnClose
	public void onClose(Session session) {
		if(waitSession.contains(session)) {
			waitSession.remove(session); // 혼자 있을떄 나가는 부분
			System.out.println("세션 하나 나감.");
		}
		else {
			Session sessionB = matching.get(session); // 세션 끊어졌을 때 상대 세션 반환
			String message = "{\"type\": \"disconnect\"}"; // {type : "disconnect"}로 메시지 설정
			try {
				if (sessionB != null) {
				handleMessage(message, sessionB); // 이미 끊어진 세션은 메시지 보낼 수 없기 때문에 상대 세션으로 주체 바꿔서 메시지 전송 
				// matching 맵에서 세션 정리 
				matching.remove(sessionB);
				matching.remove(session);
				System.out.println("게임 종료. 진행중인 게임 : "+ matching.size());
			}}catch(Exception e) {
				e.printStackTrace();
			}
		}
		clients.remove(session);
	}

	@OnError
	public void onError(Throwable error) {
		error.printStackTrace();
	}

	private void sendMessage(Session session, String message) {
		try {
			session.getBasicRemote().sendText(message);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}