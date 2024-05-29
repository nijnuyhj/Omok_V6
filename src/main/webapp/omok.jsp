<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>오목 게임</title>
    <style>
		body{
		    margin : auto;
		    width: 600px;
		}
		
		.header{
			margin: 50px auto;
		}
		#canvas-container {
		    position: relative;
		    
		    
		}
		.canvas {
		    position: absolute;
		    top: 0;
		    left: 0;
		    z-index: 1;
		    display: none; margin: 0 auto;
		}
		
		.frame {
		    position: absolute;
		    box-sizing: border-box;
		    z-index: 2;
		    top: 15px;
		    width: 30px; 
		    height: 30px;
		    opacity: 0;
		 	display: none; 
		     /* 투명도 정의  */
		    
		}
		.frame:hover {
		    opacity: 1;
		    background-color: rgba(0, 0, 0, 0.5); 
		}
		.status,.result{
			 display:flex;
			 justify-content: center;
			 align-items: center; 
		}
		.coordinate{
			 display: block;
		}
		.btn{
			padding:15px;
			border-radius: 15px;
			border: none;
			background-color: #ECE9E9;
			color: #000000;
			font-size: 20px;
		}
		
</style>
</head>
<body>
	<div class='header'>
	<h1 style="float: left;">오목 게임</h1>
	<input class="btn" type='button' value="메인화면" style="float: right;">
		<div style="clear: both">
	</div>

	<div style="display">
		<div class="status">
    		매칭 대기중
		</div>
		
		<h3 class="result">
		</h3>
</div></div>

<div class ="coordinate">ㅤㅤㅤㅤ</div>
<div style="display:flex; margin:auto">
<div id="canvas-container">
    <canvas class="canvas" width="600" height="600"></canvas>
</div></div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	var gameover = false;
	
	const canvas = document.querySelector('.canvas');
	const ctx = canvas.getContext('2d');
	const margin = 30;
	const cw = canvas.width;
	const ch = canvas.height;
	const row = 18; // 바둑판 선 개수
    const dolSize = 13;  // 바둑돌 크기
    const rowSize = 540 / row; // 바둑판 한 칸의 너비
    const container = document.getElementById('canvas-container');
    // 1. 하나하나 인덱스 번호를 받아온다.
    // 2. 배열에 그 값의 좌표 값을 넣어준다
    var StoneX; //보드에 돌 놓기용 X좌표 
    var StoneY; // 보드에 돌 놓기용 Y죄표
    var BoardX;
    var BoardY;
    var coordinate = document.querySelector(".coordinate");
    var boardSize = 19;
    var cellSize = canvas.width / boardSize;
    var currentPlayer = 1; // 1: 흑돌, 2: 백돌
    var board = [];
    var myTurn = false; // 클라이언트의 턴 여부

    for (var i = 0; i < boardSize; i++) {
        board[i] = [];
        for (var j = 0; j < boardSize; j++) {
            board[i][j] = 0; // 0: Empty, 1: Black, 2: White
        }
    }

    function updateStatus() {
    	
        var status = document.querySelector(".status");
        if(!gameover){
	        if (myTurn) {
	            status.innerHTML = "내 차례입니다.";
	        } else {
	            status.innerHTML = "상대방의 차례입니다.";
	        }
        }else{
        	status.style.display = 'none';
        }
    }
    
    function drawBoard() {
        ctx.fillStyle = '#e38d00';
        ctx.fillRect(0, 0, cw, ch);
        for (let x = 0; x < 18; x++) {
            for (let y = 0; y < 18; y++) {
                ctx.strokeStyle = 'black';
                ctx.lineWidth = 1;
                ctx.strokeRect(rowSize  * x + margin,rowSize * y+ margin,rowSize,rowSize);
            
            }
        }
        // 점 찍기
        for(let i=0; i < 3; i++){
            for(let j=0; j<3; j++){
                ctx.fillStyle ='black';
                ctx.beginPath();
                ctx.arc((margin + (3+i)*rowSize) + (i*5*rowSize), (margin + (3+j)*rowSize) + (j*5*rowSize), 5, 0, Math.PI*2)
                ctx.fill();
            }
        }
        checkBoard();
        createFrames(boardSize,boardSize);
    }
	// 좌표 확인
    function checkBoard() {
        for (var i = 0; i < boardSize; i++) {
            for (var j = 0; j < boardSize; j++) {
                if (board[i][j] === 1) {
                	BlackStone(i,j);
                } else if (board[i][j] === 2) {
                	WhiteStone(i,j);
                }
            }
        }
    }
	
    function BlackStone (ctxarcX,ctxarcY){
    	let x = (ctxarcX* rowSize) + margin;
    	let y = (ctxarcY* rowSize) + margin;
    	console.log(x);
    	console.log(y);
        ctx.fillStyle ='black';
        ctx.beginPath();
        ctx.arc(x, y, dolSize, 0, Math.PI*2)
        ctx.fill();
    }
    
    function WhiteStone (ctxarcX,ctxarcY){
    	let x = (ctxarcX*rowSize) + margin;
    	let y = (ctxarcY*rowSize) + margin;
        ctx.fillStyle ='white';
        ctx.beginPath();
        ctx.arc(x, y, dolSize, 0, Math.PI*2)
        ctx.fill();
    }
    
    
    function ClickEvents() {
        $('.frame').click(function() {
            if (!myTurn) return; // 턴이 아닐 때 클릭 이벤트 무시
            StoneX = parseInt($(this).css('left'),10)+15; 
            StoneY = parseInt($(this).css('top'),10)+15;
            BoardX = (StoneX-30)/30;
            BoardY = (StoneY-30)/30;
            coordinate.innerHTML = "(" + BoardX + "," + BoardY + ")";
            if (board[BoardX][BoardY] === 0) {
                board[BoardX][BoardY] = currentPlayer;
                drawBoard();
                var message = {
                    x: BoardX,
                    y: BoardY,
                    player: currentPlayer,
                    winner: checkWinner(BoardX, BoardY, currentPlayer) ? currentPlayer : 0
                };
                socket.send(JSON.stringify(message));
                myTurn = false;
                updateStatus();
            }
        });
    }
    
    function createFrames(rows, cols) {
        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                var frame = document.createElement('div');
                frame.className = 'frame';
                frame.style.left = (i * rowSize + margin / 2) + 'px';
                frame.style.top = (j * rowSize + margin / 2) + 'px';
                frame.style.width = rowSize + 'px';
                frame.style.height = rowSize + 'px';
                container.appendChild(frame);
            }
        }
     
        ClickEvents(); 
    }

    function checkWinner(x, y, player) {
        // 수평 체크
        var count = 1;
        // 좌측으로 이동
        for (var i = x - 1; i >= 0; i--) {
            if (board[i][y] === player) {
                count++;
            } else {
                break;
            }
        }
        // 우측으로 이동
        for (var i = x + 1; i < boardSize; i++) {
            if (board[i][y] === player) {
                count++;
            } else {
                break;
            }
        }
        if (count >= 5) {
            if (player === currentPlayer) {
                return true;
            }
        }

        // 수직 체크
        count = 1;
        // 위로 이동
        for (var j = y - 1; j >= 0; j--) {
            if (board[x][j] === player) {
                count++;
            } else {
                break;
            }
        }
        // 아래로 이동
        for (var j = y + 1; j < boardSize; j++) {
            if (board[x][j] === player) {
                count++;
            } else {
                break;
            }
        }
        if (count >= 5) {
            if (player === currentPlayer) {
                return true;
            }
        }

        // 대각선 체크 (왼쪽 위에서 오른쪽 아래로)
        count = 1;
        var i = x - 1;
        var j = y - 1;
        while (i >= 0 && j >= 0) {
            if (board[i][j] === player) {
                count++;
                i--;
                j--;
            } else {
                break;
            }
        }
        i = x + 1;
        j = y + 1;
        while (i < boardSize && j < boardSize) {
            if (board[i][j] === player) {
                count++;
                i++;
                j++;
            } else {
                break;
            }
        }
        if (count >= 5) {
            if (player === currentPlayer) {
                return true;
            }
        }

        // 대각선 체크 (오른쪽 위에서 왼쪽 아래로)
        count = 1;
        i = x + 1;
        j = y - 1;
        while (i < boardSize && j >= 0) {
            if (board[i][j] === player) {
                count++;
                i++;
                j--;
            } else {
                break;
            }
        }
        i = x - 1;
        j = y + 1;
        while (i >= 0 && j < boardSize) {
            if (board[i][j] === player) {
                count++;
                i--;
                j++;
            } else {
                break;
            }
        }
        if (count >= 5) {
            if (player === currentPlayer) {
                return true;
            }
        }

        return false;
    }

    function resetBoard() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        for (var i = 0; i < boardSize; i++) {
            for (var j = 0; j < boardSize; j++) {
                board[i][j] = 0;
            }
        }
        drawBoard();
    }

    drawBoard();
    var btn = document.querySelector(".btn");
    btn.addEventListener('click', function() {
    	if(!gameover){
    		loseInfo();
    	}
        location.href = '<%=request.getContextPath()%>';
    });
    
    // 웹 소켓 서버의 주소
    var socketUrl = "ws://localhost:8090/Omok/omok";
    var playerNumber = -1; // 플레이어 번호

    // 웹 소켓 객체 생성
    var socket = new WebSocket(socketUrl);

    // 소켓이 열릴 때 호출되는 함수
    socket.onopen = function(event) {
        console.log("연결 성공하셨습니다");
     // 내 브라우저 세션에 있는 id 정보 가져오기
    	const userId = sessionStorage.getItem('userId');
    	const userId1 = '<%= (String)session.getAttribute("userId") %>';
    	console.log(userId1);
    };

    // 소켓이 닫힐 때 호출되는 함수
    socket.onclose = function(event) {
        console.log("연결이 끊겼습니다");
    };

    // 소켓 에러가 발생했을 때 호출되는 함수
    socket.onerror = function(error) {
        console.error("WebSocket error: " + error.message);
    };

 	// 서버에서 메시지가 오면 호출되는 함수
   socket.onmessage = function(event) {
 		
    var message = JSON.parse(event.data);

    var x = message.x;
    var y = message.y;

    if (message.type === "matchingStatus"){
        if (message.matchingStatus === true) {
            canvas.style.display = "block";
            var frames = document.querySelectorAll('.frame');
            frames.forEach(tile => tile.style.display = 'block');
        }
    } else if (message.type === "playerNumber") {
        // 플레이어 번호를 할당받음
        playerNumber = message.playerNumber;
        console.log("Player Number: " + playerNumber);
        // 플레이어 번호에 따라 돌의 색깔 결정
        if (playerNumber === 1) {
            currentPlayer = 1; // 흑돌
        } else if (playerNumber === 2) {
            currentPlayer = 2; // 백돌
        }
        myTurn = (currentPlayer === 1); // 플레이어 1의 턴일 때만 이벤트 활성화
    } else if (message.type === "winner") {
        drawBoard();
        gameover = true;
            var result = document.querySelector('.result');
        if (message.playerNumber === currentPlayer) {
        	console.log('이김');
            winInfo();
            result.innerText='승리';
            
        } else {
        	console.log('패배');
            loseInfo();
            result.innerText='패배';
        }
        var frames = document.querySelectorAll('.frame');
        frames.forEach(tile => tile.style.display = 'none');
    } else if (message.type === "disconnect" && gameover == false) { // 상대가 나감
    	var result = document.querySelector('.result')
    	console.log('이김');
        winInfo();
        result.innerText='승리';
        alert('상대방이 나가서 게임을 승리하셨습니다');
        gameover=true;
        var frames = document.querySelectorAll('.frame');
        frames.forEach(tile => tile.style.display = 'none');
    } else {
        var player = message.player;
        // 상대방이 놓은 돌을 클라이언트의 화면에 표시
        board[x][y] = player;
        drawBoard();
        myTurn = (player !== currentPlayer); // 턴 변경
    }
    updateStatus();
};
	function winInfo(){
	$.ajax({
        url:"http://localhost:8090/Omok/winlosecon",  // 서버 측 URL
        type: 'post',      // HTTP 요청 방식 (GET, POST)
        dataType: 'json', // 서버에서 반환되는 데이터 타입
        async: false,
        data:{win:"1",lose:"0"},
        success: function(response) {

        },
        error: function() {

        }
    });
	}
	function loseInfo(){
		$.ajax({
			url: "http://localhost:8090/Omok/winlosecon",  // 서버 측 URL
	        type: 'post',      // HTTP 요청 방식 (GET, POST)
	        dataType:'json', // 서버에서 반환되는 데이터 타입
	        async: false,
	        data:{win:"0",lose:"1"},
	        success: function(response) {

	        },
	        error: function() {
	   
	        }
	    });
		}
</script>

</body>
</html>