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
<div id = "HowToPlay"><Strong>HOW TO PLAY :</Strong> Ű������ <span>����Ű�� �̿��Ͽ�</span> ���� �����̼���!<br>
���� ������ ���� ������ �������� ���� <span>2�� Ŀ���ϴ�.</span><br> ���� ��ġ�� <span>������ ȹ���ϼ���!</span><br>
<span>Game Over</span>��, <span>EnterŰ�� ����</span> �ٽ� �����غ�����!
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
  
  //data �迭�� �� ������ user_score�� �����ŵ�ϴ�.
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
  
  // ������ �����ϴ� �Լ�
  function resetGame(){
	//������ score�� �����ϸ� ������Ʈ �� ������ �˷��ݴϴ�.
	user_ref.once('value',function(snapshot){
		var tmp = snapshot.val();
		if(lastscore == tmp.user_score){
			alert("���� ����! ���� " + tmp.user_rank +"���� ��ũ �Ǿ����ϴ�!");
		}
	});
    loss = false;
	//jquery�� �̿��Ͽ� canvas(����ȭ��)�� ������ �ٽ� �ø��ϴ�.
    $('canvas').animate({
        opacity : 1.0
      },1000);
    score = 0;
    scoreLabel.innerHTML = score
    startGame();
  }

  function startGame() {
	//user�� bestscore�� �����ͺ��̽����� ���� �� bestLabel�� ���ϴ�.
	user_ref.once('value',function(snapshot){
		var tmp = snapshot.val();
		bestscore = tmp.user_score;
		bestLabel.innerHTML = bestscore;
	});
	usercomment.innerHTML = id + "��, �ݰ����ϴ�! Rank ������ �����غ���!";
	
	//rankscore�� �����ͺ��̽����� ���� �� rankLabel�� ���ϴ�.
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
  
  //������ ������ �Լ�
  function finishGame() {
	var rank;
	//jquery�� �̿��Ͽ� canvas(���� ȭ��)�� ������ 0.3��ŭ ���ҽ�ŵ�ϴ�.
	$('canvas').animate({
		  opacity : 0.3
		},1500);
    loss = true;
    lastscore = score;
    //�ڽ��� �ְ� ���ھ �������� ���
    if(score>=bestscore){
    	//�����ͺ��̽� ���� �ڽ��� ���ھ ������Ʈ�մϴ�.
    	user_ref.update({
    		user_score : score
    	});
    	
    	//data�迭�� �ڽ��� ���� ���ھ�� ���� ���ھ ���� ���� �� �����մϴ�.
    	for(var i = 0; i < data.length; i++){
    		if(bestscore == data[i]){
    			data.splice(i,1);
    			data.push(score);
    		}
    	}
    	// data �迭�� score�� �������� �����մϴ�.
    	data.sort(function(a,b){return b-a;});
    	
    	
    	//�ٲ� �ڽ��� ���ھ ���߾� ��� ������ ��ŷ�� ������Ʈ�մϴ�.
    	user_data.once('value', function(snapshot){
    		snapshot.forEach(function(childSnapshot){
    			var tmp = childSnapshot.val();
        		var user_ref = firebase.database().ref('user_profile/'+tmp.user_id);
				//data �迭�� ��Ƶ� score��� �� �������� score�� ���մϴ�.
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
    //��ũ ���ھ �������� ��� �����ͺ��̽� ���� ��ũ ���ھ ������Ʈ�մϴ�.
    if(score>=rankscore){
    	var best_ref = firebase.database().ref("Best_score");
    	best_ref.update({
    		Score : score
    	});
    }
  }
  // ��� ��ġ�� 
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
    //�����ִ� ������ ������ ���� ����
    if(!countFree) {
      finishGame();
      return;
    }
    // �������� �ڸ��� cell�� �׸��ϴ�.
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
  
  	// �����ڸ�� ���� Ȯ�� �Լ�
    function Admin(){
      var AdminPW = prompt("������ KeyCode�� �Է��ϼ���.");
      //�����ڷ� �α��� �������� �����մϴ�.
      if(id == "admin"){
    	  // �����ͺ��̽��κ��� Keycode���� �ҷ��ɴϴ�.
          var keycode = firebase.database().ref('Administrator');
      	  keycode.once('value',function(snapshot){
  			var tmp = snapshot.val();
  			if(tmp.KeyCode == AdminPW){
  				window.location.href = "Admin.jsp";
  			}
  			else{
				alert("�Է��� keyCode�� �߸��Ǿ����ϴ�.");
			}
  	  	});
      }
      else{
      	alert("�����ڸ� ������ �� �ֽ��ϴ�.");
      }
    }
  </script>

</body>
</html>
    