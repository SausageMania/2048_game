<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE <!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>2048-Rank</title>

<style>
html{
    width: 100%;
    height: 100%;
}
body{
    background: -webkit-linear-gradient(45deg, rgba(255, 255, 255, 0.8) 0%, rgba(45, 99, 247, 0.466) 100%);
    background: linear-gradient(45deg, rgba(255, 255, 255, 0.8) 0%,rgba(45, 99, 247, 0.466) 100%);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-family: "roboto", "Arial";
    margin : 80px 0;
}
.game-tool, .user-tool, .history{
    width : 500px;
    margin : 0 auto;
}

.rank-container{
    width : 600px;
    margin : 0 auto;
}

.game-tool:after , .user-tool:after{
    content: "";
    display: block;
    clear: both;
    height: 5px;
}

.game-name{
    font-weight: 700;
    font-size: 65px;
    color: rgb(16, 102, 240);
    float : left;
    display : block;
}

.game-name span{
    color : rgb(113, 16, 240);
}

.user-tool{
    font-size: 18px;
    color: black;
    font-family: "Clear Sans","새굴림";
    font-weight: 500;
}

.user-tool span{
    color : rgb(113, 16, 240);
}

.rank-table li{
    padding : 0 0 10px 0;
}

.rank-table li ul li{
    display : inline;
}

#user-id:after{
	content: "";
    display: block;
    clear: both;
    width: 10px;
}
.user-comment{
	display : inline;
}

#your-rank{
	font-weight : 900;
	color :
}



#checkAll{
    width:80px;
    height: 40px;
    background-color: #f0797b;
    border: none;
    border-radius : 6px;
    color:#fff;
    padding: 5px 0;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 15px;
    margin: 20px 0 0 10px;
    cursor: pointer;
}

</style>
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
            <div class = "game-name">2048 <span>Ranking</span></div>
        </div>
        <div class = "user-tool">
            <div class = "user-comment"><span id = "your-id"></span>님, 현재 당신의 순위는 <span id = "your-rank"></span>위입니다.&nbsp;&nbsp;&nbsp;</div>
            <input type = "button" id = "checkAll" value = "전체확인" onclick = "Rank()">
        </div>
        <div class = "rank-container">
            <ol type ="1" class = "rank-table" id = "rank-table">
                
            </ol>
        </div>
        <div class = "history">
        	<a href = "#" onclick  = "History()">돌아가기</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href = "HomePage.jsp">로그아웃</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href = "#" onclick = "Admin()">관리자모드</a>
        	
        </div>
        
    </div>


    <script>
        var id;
        var score;
        var score_data = new Array();
        var id_data = new Array();
        var sort_score = new Array();
        var enable = new Boolean();
        enable = true;
        var ID = "<%=id%>";
        var your_rank = document.getElementById("your-rank");
        var your_id = document.getElementById("your-id");
		your_id.innerHTML = ID;
        
        var user_data = firebase.database().ref('user_profile');
    	user_data.on('value', function(snapshot) {
            score_data.splice(0, score_data.length);
            id_data.splice(0,id_data.length);
            snapshot.forEach(function(childSnapshot) {
              var childData = childSnapshot.val();
              score_data.push(childData.user_score);
              id_data.push(childData.user_id);
            });
          });


    	var user_ref = firebase.database().ref('user_profile/'+ID);
    	user_ref.once('value',function(snapshot){
    		var tmp = snapshot.val();
    		your_rank.innerHTML = tmp.user_rank;
    	});
    	
    	
        //모든 유저의  Ranking을 확인하는 함수.
        //만약 게임을 플레이 하지 않았을 시 랭킹에 반영되지 않습니다.
        function Rank(){
        	var li = new Array();
        	var user = new Array();
        	var userID = new Array();
        	var userScore = new Array();
        	var table = document.getElementById("rank-table");
        
        	
        	sort_score = score_data.slice();
        	sort_score.sort(function(a,b){return b-a;});
        	if(enable){
        	for(var i=0; i<sort_score.length; i++){
				for(var j=0; j<score_data.length;j++){
					if(sort_score[i] == score_data[j] && score_data[j] != 0){
						id = id_data[j];
						score = score_data[j];
						li[j] = document.createElement("li");
						user[j] = document.createElement("ul");
						
						userID[j] = document.createElement("li");
						userID[j].setAttribute("id","user-id");
						userID[j].innerHTML = "ID : " + id;
						
						userScore[j] = document.createElement("li");
						userScore[j].setAttribute("id","user-score");
						userScore[j].innerHTML = "점수 : " + score + "점";
						
						
						user[j].appendChild(userID[j]);
			            user[j].appendChild(userScore[j]);
			            li[j].appendChild(user[j]);

						table.appendChild(li[j]);
						break;
					}
				}
        	}
        	enable = false;
        	}
        }
        
        function Admin(){
            var AdminPW = prompt("관리자 KeyCode를 입력하세요.");
            if(ID == "admin"){
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
        
        function History(){
            history.back();
        }
        
    </script>
    
    
</body>
</html>