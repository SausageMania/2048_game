<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<!DOCTYPE html>
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
    font-family: "Clear Sans","������";
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

.user-id:after{
	content: "";
    display: block;
    clear: both;
    width: 10px;
}
.user-pw:after{
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

.id-text{
display : inline;
}

.deletebox{
	width:47px;
    height: 25px;
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

.deletebox:after{
	content: "";
    display: block;
    clear: both;
    height: 5px;
}

.user-comment span{
    font-weight : 900;
}

</style>
</head>
<body>
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
            <div class = "game-name">2048 <span>�����ڸ��</span></div>
        </div>
        <div class = "user-tool">
            <div class = "user-comment"><span>�����ڴ�</span> ȯ���մϴ�.</div>
            <input type = "button" id = "checkAll" value = "����Ȯ��" onclick = "Admin()">
        </div>
        <div class = "rank-container">
            <ol type ="1" class = "rank-table" id = "rank-table">
                
            </ol>
        </div>
        <div class = "history">
        	<a href = "Game2048.jsp">���ư���</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href = "HomePage.jsp">�α׾ƿ�</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href = "Rank.jsp">��ŷȮ��</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href = "#" onclick = "changeKey()">KeyCode ����</a>
        	
        </div>
        
    </div>


    <script>
        var id;
        var pwd;
        var email;

        var email_data = new Array();
        var id_data = new Array();
        var pw_data = new Array();

        var enable = new Boolean();
        enable = true;
        
        var user_data = firebase.database().ref('user_data');
    	user_data.on('value', function(snapshot) {
            email_data.splice(0, email_data.length);
            id_data.splice(0,id_data.length);
            pw_data.splice(0,pw_data.length);

            snapshot.forEach(function(childSnapshot) {
              var childData = childSnapshot.val();
              email_data.push(childData.user_email);
              id_data.push(childData.user_id);
              pw_data.push(childData.user_pwd);
            });
          });
    	
    	
        //��� ������ ȸ�������� Ȯ���ϴ� �Լ�
        function Admin(){
        	var li = new Array();
        	var user = new Array();
        	var userID = new Array();
        	var userPW = new Array();
            var userEM = new Array();
            var idText = new Array();

        	var table = document.getElementById("rank-table");
        	var deletebox; 

        	if(enable){
                for(j=0;j<id_data.length;j++){
				    id = id_data[j];
                    pwd = pw_data[j];
                    email = email_data[j];
						
				    li[j] = document.createElement("li");
				    user[j] = document.createElement("ul");
					
				    idText[j] = document.createElement("div");
				    idText[j].setAttribute("class","id-text");
				    idText[j].innerHTML = id +"&nbsp;&nbsp;";
				    
				    userID[j] = document.createElement("li");
				    userID[j].setAttribute("class","user-id");
				    userID[j].innerHTML = "���̵� : " + id;
						
				    userPW[j] = document.createElement("li");
				    userPW[j].setAttribute("class","user-pw");
				    userPW[j].innerHTML = "��й�ȣ : " + pwd;

                    userEM[j] = document.createElement("li");
				    userEM[j].setAttribute("class","user-email");
				    userEM[j].innerHTML = "�̸��� : " + email;
						
					
				    deletebox = document.createElement("input");
				    deletebox.setAttribute("class","deletebox");
				    deletebox.setAttribute("id",j);
				    deletebox.type = "button";
				    deletebox.value = "����"
				    deletebox.onclick = function(){
				    	var box_value = parseInt(this.getAttribute("id"));
				    	var user_id = id_data[box_value];
				    	var user_profile = firebase.database().ref('user_profile/'+user_id);
				    	var user_data = firebase.database().ref('user_data/'+user_id);
				    	user_data.remove();
				    	user_profile.remove();
				    	
				    	alert(user_id+"���� ȸ�������� �����Ǿ����ϴ�.");
				    }
				    
				    user[j].appendChild(userID[j]);
			        user[j].appendChild(userPW[j]);
                    user[j].appendChild(userEM[j]);
                    
                    li[j].appendChild(idText[j]);
			        li[j].appendChild(deletebox);
			        li[j].appendChild(user[j]);

				    table.appendChild(li[j]);
                }
        	enable = false;
        	}
        }
        
        //������ ��й�ȣ�� �ٲٴ� �Լ�
        function changeKey(){
        	var AdminPW = prompt("������ KeyCode�� �Է��ϼ���.");
            var keycode = firebase.database().ref('Administrator');
            keycode.once('value',function(snapshot){
        		var tmp = snapshot.val();
        		if(tmp.KeyCode == AdminPW){
        			var keychange = prompt("�ٲ� KeyCode�� �Է��ϼ���.");
        			var key_data = firebase.database().ref('Administrator');
        			key_data.update({
        				KeyCode : keychange
        			});
        			
        		}
        		else{
        			alert("�߸� �Է��ϼ̽��ϴ�.");
        		}
        	  });
        	
        	
        }
        
        
        function History(){
            history.back();
        }
        
    </script>
    
    
</body>
</html>