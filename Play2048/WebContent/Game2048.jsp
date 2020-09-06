<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link href="Gamestyle.css" rel="stylesheet">
  <title>2048</title>
</head>
<body>
<% String id = (String) session.getAttribute("id"); %>
<script src="https://www.gstatic.com/firebasejs/5.5.9/firebase.js"></script>
<script>

  // Initialize Firebase
  var config = {
    apiKey: "AIzaSyAjg0doqHhzd0-v3f7TaOHG_PRMMNZK-fM",
    authDomain: "internet-programming-7619a.firebaseapp.com",
    databaseURL: "https://internet-programming-7619a.firebaseio.com",
    projectId: "internet-programming-7619a",
    storageBucket: "internet-programming-7619a.appspot.com",
    messagingSenderId: "99018689333"
  };
  firebase.initializeApp(config);
</script>

<div class = "game-container">

  <div class = "game-tool">
    <div class = "game-name">2048</div>
    <div class = "score-container">
      <div class="score" id = "score"></div>
      <div class="bestscore" id = "bestscore"></div>
      <div class="rankscore" id = "rankscore"></div>
    </div>
  </div>

  <div class = "user-tool" id = "usercomment"></div>

  <div id="size-bloc">
    <div class="clear"></div>
  </div>
  <div id="canvas-block">
    <canvas id="canvas" width="500" height="500"></canvas>
  </div>
</div>
<hr>
<div class = "menu-container">
  <ul>
      <li>
          <a href = "Rank.jsp">Ranking</a>
      </li>
      <li>
          <a href = "HomePage.jsp">Logout</a>
      </li>
      <li>
          <a href = "#" onclick = "Admin()">Admin Mode</a>
      </li>

  </ul>
</div>
<hr>
<div id = "HowToPlay"><Strong>HOW TO PLAY :</Strong> 키보드의 <span>방향키를 이용하여</span> 블럭을 움직이세요!<br>
같은 숫자의 블럭이 닿으면 합쳐지며 수가 <span>2배 커집니다.</span><br> 블럭을 합치며 <span>점수를 획득하세요!</span><br>
<span>Game Over</span>시, <span>Enter키를 눌러</span> 다시 도전해보세요!
</div>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script>
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  var sizeInput = document.getElementById('size');
  var changeSize = document.getElementById('change-size');
  var scoreLabel = document.getElementById('score');
  var bestLabel = document.getElementById('bestscore');
  var rankLabel = document.getElementById('rankscore');
  var usercomment = document.getElementById('usercomment');
  var score = 0;
  var bestscore = 0;
  var rankscore = 0;
  var size = 4;
  var width = canvas.width / size - 6;
  var cells = [];
  var fontSize;
  var loss = false;
  var id = "<%=id %>";
  var lastscore = 0;
  
  var rank_ref = firebase.database().ref('Best_score');
  var user_ref = firebase.database().ref('user_profile/'+id);
  
  //data 배열에 각 유저의 user_score를 저장시킵니다.
  var user_data = firebase.database().ref('user_profile');
  var data = new Array();
  user_data.once('value', function(snapshot) {
      data.splice(0, data.length);
      snapshot.forEach(function(childSnapshot) {
        var childData = childSnapshot.val();
        data.push(childData.user_score);
      });
    });
  
  scoreLabel.innerHTML = score;
  bestLabel.innerHTML = bestscore;
  
  startGame();

  function cell(row, coll) {
    this.value = 0;
    this.x = coll * width + 5 * (coll + 1);
    this.y = row * width + 5 * (row + 1);
  }

  function createCells() {
    var i, j;
    for(i = 0; i < size; i++) {
      cells[i] = [];
      for(j = 0; j < size; j++) {
        cells[i][j] = new cell(i, j);
      }
    }
  }

  function drawCell(cell) {
    ctx.beginPath();
    ctx.rect(cell.x, cell.y, width, width);
    switch (cell.value){
      case 0 : ctx.fillStyle = '#A9E2F3'; break;
      case 2 : ctx.fillStyle = '#F7BE81'; break;
      case 4 : ctx.fillStyle = '#FF7F50'; break;
      case 8 : ctx.fillStyle = '#ffbf00'; break;
      case 16 : ctx.fillStyle = '#74DF00'; break;
      case 32 : ctx.fillStyle = '#01DFD7'; break;
      case 64 : ctx.fillStyle = '#0040FF'; break;
      case 128 : ctx.fillStyle = '#FE2E2E'; break;
      case 256 : ctx.fillStyle = '#BE81F7'; break;
      case 512 : ctx.fillStyle = '#ff0080'; break;
      case 1024 : ctx.fillStyle = '#D2691E'; break;
      case 2048 : ctx.fillStyle = '#FF7F50'; break;
      case 4096 : ctx.fillStyle = '#8904B1'; break;
      default : ctx.fillStyle = '#ff0080';
    }
    ctx.fill();
    if (cell.value) {
      if(cell.value < 1024){
        fontSize = width / 2;
      }else{
        fontSize = width / 2.5;
      }
      
      ctx.font = fontSize + 'px Arial';
      ctx.fillStyle = 'white';
      ctx.textAlign = 'center';
      ctx.fillText(cell.value, cell.x + (width / 2),cell.y + (width / 2) + width/7);
    }
  }

  
  function canvasClean() {
    ctx.clearRect(0, 0, 500, 500);
  }

  document.onkeydown = function (event) {
    if (loss == false) {
      if (event.keyCode === 38 || event.keyCode === 87) {
        moveUp(); 
      } else if (event.keyCode === 39 || event.keyCode === 68) {
        moveRight();
      } else if (event.keyCode === 40 || event.keyCode === 83) {
        moveDown(); 
      } else if (event.keyCode === 37 || event.keyCode === 65) {
        moveLeft(); 
      }
      scoreLabel.innerHTML = score;
	  if(score > rankscore){
		  rankLabel.innerHTML = score;
	  }
	  if(score > bestscore){
		  bestLabel.innerHTML = score;
	  }
    }
    else{
      if(event.keyCode === 13){
        resetGame();
      }
    }
    
    
  }
  
  // 게임을 리셋하는 함수
  function resetGame(){
	//본인의 score를 갱신하면 업데이트 된 순위를 알려줍니다.
	user_ref.once('value',function(snapshot){
		var tmp = snapshot.val();
		if(lastscore == tmp.user_score){
			alert("점수 갱신! 현재 " + tmp.user_rank +"위에 랭크 되었습니다!");
		}
	});
    loss = false;
	//jquery를 이용하여 canvas(게임화면)의 투명도를 다시 올립니다.
    $('canvas').animate({
        opacity : 1.0
      },1000);
    score = 0;
    scoreLabel.innerHTML = score
    startGame();
  }

  function startGame() {
	//user의 bestscore를 데이터베이스에서 추출 후 bestLabel에 띄웁니다.
	user_ref.once('value',function(snapshot){
		var tmp = snapshot.val();
		bestscore = tmp.user_score;
		bestLabel.innerHTML = bestscore;
	});
	usercomment.innerHTML = id + "님, 반갑습니다! Rank 점수에 도전해봐요!";
	
	//rankscore를 데이터베이스에서 추출 후 rankLabel에 띄웁니다.
	rank_ref.once('value',function(snapshot){
		  var tmp = snapshot.val();
		  rankscore = tmp.Score;
		  rankLabel.innerHTML = rankscore;
	});
    createCells();
    drawAllCells();
    pasteNewCell();
    pasteNewCell();
  }
  
  //게임을 끝내는 함수
  function finishGame() {
	var rank;
	//jquery를 이용하여 canvas(게임 화면)의 투명도를 0.3만큼 감소시킵니다.
	$('canvas').animate({
		  opacity : 0.3
		},1500);
    loss = true;
    lastscore = score;
    //자신의 최고 스코어를 갱신했을 경우
    if(score>=bestscore){
    	//데이터베이스 내의 자신의 스코어를 업데이트합니다.
    	user_ref.update({
    		user_score : score
    	});
    	
    	//data배열에 자신의 현재 스코어와 이전 스코어를 각각 삽입 및 삭제합니다.
    	for(var i = 0; i < data.length; i++){
    		if(bestscore == data[i]){
    			data.splice(i,1);
    			data.push(score);
    		}
    	}
    	// data 배열의 score를 내림차순 정렬합니다.
    	data.sort(function(a,b){return b-a;});
    	
    	
    	//바뀐 자신의 스코어에 맞추어 모든 유저의 랭킹을 업데이트합니다.
    	user_data.once('value', function(snapshot){
    		snapshot.forEach(function(childSnapshot){
    			var tmp = childSnapshot.val();
        		var user_ref = firebase.database().ref('user_profile/'+tmp.user_id);
				//data 배열에 담아둔 score들과 각 유저들의 score를 비교합니다.
        		for(var j = 0; j<data.length;j++){
        			rank = j + 1;
            		if(tmp.user_score == data[j]){
            			user_ref.update({
            				user_rank : rank
            			});
            			break;
            		}
            	}
    		});
    	});
    	
    }
    //랭크 스코어를 갱신했을 경우 데이터베이스 내의 랭크 스코어를 업데이트합니다.
    if(score>=rankscore){
    	var best_ref = firebase.database().ref("Best_score");
    	best_ref.update({
    		Score : score
    	});
    }
  }
  // 모든 위치에 
  function drawAllCells() {
    var i, j;
    for(i = 0; i < size; i++) {
      for(j = 0; j < size; j++) {
        drawCell(cells[i][j]);
      }
    }
  }

  function pasteNewCell() {
    var countFree = 0;
    var i, j;
    for(i = 0; i < size; i++) {
      for(j = 0; j < size; j++) {
        if(!cells[i][j].value) {
          countFree++;
        }
      }
    }
    //남아있는 공간이 없으면 게임 종료
    if(!countFree) {
      finishGame();
      return;
    }
    // 무작위의 자리에 cell을 그립니다.
    while(true) {
      var row = Math.floor(Math.random() * size);
      var coll = Math.floor(Math.random() * size);
      if(!cells[row][coll].value) {
        cells[row][coll].value = 2 * Math.ceil(Math.random() * 2);
        drawAllCells();
        return;
      }
    }
  }

  function moveRight () {
    var i, j;
    var coll;
    for(i = 0; i < size; i++) {
      for(j = size - 2; j >= 0; j--) {
        if(cells[i][j].value) {
          coll = j;
          while (coll + 1 < size) {
            if (!cells[i][coll + 1].value) {
              cells[i][coll + 1].value = cells[i][coll].value;
              cells[i][coll].value = 0;
              coll++;
            } else if (cells[i][coll].value == cells[i][coll + 1].value) {
              cells[i][coll + 1].value *= 2;
              score +=  cells[i][coll + 1].value;
              cells[i][coll].value = 0;
              break;
            } else {
              break;
            }
          }
        }
      }
    }
    pasteNewCell();
  }

  function moveLeft() {
    var i, j;
    var coll;
    for(i = 0; i < size; i++) {
      for(j = 1; j < size; j++) {
        if(cells[i][j].value) {
          coll = j;
          while (coll - 1 >= 0) {
            if (!cells[i][coll - 1].value) {
              cells[i][coll - 1].value = cells[i][coll].value;
              cells[i][coll].value = 0;
              coll--;
            } else if (cells[i][coll].value == cells[i][coll - 1].value) {
              cells[i][coll - 1].value *= 2;
              score +=   cells[i][coll - 1].value;
              cells[i][coll].value = 0;
              break;
            } else {
              break; 
            }
          }
        }
      }
    }
    pasteNewCell();
  }

  function moveUp() {
    var i, j, row;
    for(j = 0; j < size; j++) {
      for(i = 1; i < size; i++) {
        if(cells[i][j].value) {
          row = i;
          while (row > 0) {
            if(!cells[row - 1][j].value) {
              cells[row - 1][j].value = cells[row][j].value;
              cells[row][j].value = 0;
              row--;
            } else if (cells[row][j].value == cells[row - 1][j].value) {
              cells[row - 1][j].value *= 2;
              score +=  cells[row - 1][j].value;
              cells[row][j].value = 0;
              break;
            } else {
              break; 
            }
          }
        }
      }
    }
    pasteNewCell();
  }

  function moveDown() {
    var i, j, row;
    for(j = 0; j < size; j++) {
      for(i = size - 2; i >= 0; i--) {
        if(cells[i][j].value) {
          row = i;
          while (row + 1 < size) {
            if (!cells[row + 1][j].value) {
              cells[row + 1][j].value = cells[row][j].value;
              cells[row][j].value = 0;
              row++;
            } else if (cells[row][j].value == cells[row + 1][j].value) {
              cells[row + 1][j].value *= 2;
              score +=  cells[row + 1][j].value;
              cells[row][j].value = 0;
              break;
            } else {
              break; 
            }
          }
        }
      }
    }
    pasteNewCell();
  }
  
  	// 관리자모드 접속 확인 함수
    function Admin(){
      var AdminPW = prompt("관리자 KeyCode를 입력하세요.");
      //관리자로 로그인 했을때만 가능합니다.
      if(id == "admin"){
    	  // 데이터베이스로부터 Keycode값을 불러옵니다.
          var keycode = firebase.database().ref('Administrator');
      	  keycode.once('value',function(snapshot){
  			var tmp = snapshot.val();
  			if(tmp.KeyCode == AdminPW){
  				window.location.href = "Admin.jsp";
  			}
  			else{
				alert("입력한 keyCode가 잘못되었습니다.");
			}
  	  	});
      }
      else{
      	alert("관리자만 접속할 수 있습니다.");
      }
    }
  </script>

</body>
</html>
    