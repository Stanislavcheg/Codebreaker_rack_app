$( document ).ready(function() {
	var display = $('#display');
	var input = $('#inputGuess');
	var guessBtn = $('#buttonGuess');

	$('#start-btn').on('click', function() {
		guessBtn.removeClass('disabled');
		$.get( "/start", function(data) {
	  		display.html(data);
		});
	});

	$('#hint-btn').on('click', function() {
		$.get( "/hint", function(data) {
	  		display.html(data);
		});
	});

	$('#rules-btn').on('click', function() {
		$.get( "/rules", function(data) {
	  		display.html(data);
		});
	});

	$('#scores-btn').on('click', function() {
		$.get( "/scores", function(data) {
	  		display.html(data);
		});
	});

	guessBtn.on('click',function(){
	    $.post("/guess",
	    {
	        guess: input.val()
	    },
	    function(data){
	    	if(data === "win") {
	    		$('#win').modal('show');
	    		endGame();
	    	}
	    	else if(data === "lost") {
	    		$('#lost').modal('show');
	    		endGame();
	    	}
	        else display.html(data);
	        input.val("");
	    });
	});

	$('#saveScore-btn').on('click', function() {
		$('#win').modal('hide');
		$('#enterName').modal('show');
	});

	$('#saveScore-btn').on('click', function() {
		$('#win').modal('hide');
		$('#enterName').modal('show');
	});

	$("#saveName-btn").on('click', function(){
	    name = $('#name').val();
	    if (name) {
		    $.post("/save_score",
		    {
		        name: name
		    },
		    function(data){
		        display.html(data);
		    });
		}
		$('#enterName').modal('hide');
	});

	function endGame() {
		display.html('Click "Start" to play');
		$("#buttonGuess").addClass('disabled');
	}
});

