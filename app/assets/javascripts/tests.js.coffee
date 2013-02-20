question_num = 0
all_data = []
started = false

window.addEventListener 'load', () ->
	new FastClick(document.body);
, false

color_map = {
	Red: "#CC0000",
	Brown: "#7B4A12",
	Green: "#266A2E",
	Purple:"#8C489F"
}

combinations = [
	{"color":"Purple", "text":"Brown"},
	{"color":"Red", "text":"Red"},
	{"color":"Green", "text":"Purple"},
	{"color":"Brown", "text":"Purple"},
	{"color":"Purple", "text":"Green"},
	{"color":"Brown", "text":"Brown"},
	{"color":"Purple", "text":"Purple"},
	{"color":"Red", "text":"Green"},
	{"color":"Purple", "text":"Brown"},
	{"color":"Green", "text":"Purple"}
]

fisher_yates = (arr) ->
	m = arr.length
	while m
		i = Math.floor(Math.random() * m-=1)
		t = arr[m]
		arr[m] = arr[i]
		arr[i] = t
	arr


next_test = () ->
	attempts = 0
	t_start = Date.now()
	color = combinations[question_num].color
	word = combinations[question_num].text
	$(".test-text").text(word).css("color", color_map[color])
	$("#button_list").empty()
	fisher_yates(Object.keys(color_map)).map (name) ->
		$("<button>")
			.addClass("btn btn-large")
			.text(name)
			.appendTo("#button_list")
			.one 'click', ->
				attempts += 1
				if name is color
					question_num += 1
					all_data.push({
						color: color,
						word: word,
						elapsed: Date.now() - t_start,
						attempts: attempts,
						num:question_num,
						isInterference:false
					})
					splash()
				else
					$(this).remove()

splash = () ->
	$(".test-container").hide()
	$(".splash-screen").removeClass("hidden")
	$(".progress-text").text(question_num + "/" + combinations.length)
	$(".bar").css("width",  (question_num/combinations.length)*100 + "%")

	if not started
		$(".btn-start").one 'click', ->
			started = true
			$(this).remove()
			$(".btn-next").removeClass("hidden")
			unsplash()
	else if question_num < combinations.length
		$(".btn-next").one 'click', ->
			unsplash()
	else
		finished()

unsplash = () ->
	$(".test-container").show()
	$('.splash-screen').addClass("hidden")
	next_test()

finished = () ->
	id = window.location.pathname.split('/')[2]
	$('form').get(0).setAttribute('action', "/test/"+id+"/submit-data")
	$("form").append($("<input>", {type: "hidden", name: "test_data"}).val(JSON.stringify(all_data))).submit()




	#window.location = "/participants/" +  id + "/survey"



splash()
