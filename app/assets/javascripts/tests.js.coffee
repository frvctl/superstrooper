question_num = 0
display_num = 0
all_data = []
started = false
control_over = false
color_instructions = "<strong> Instructions</strong> Click on
			the button whose text corresponds to the
			<b>color</b> of the large text below. Do
			this as <b>quickly and accurately</b> as possible."

window.addEventListener 'load', () ->
	new FastClick(document.body)
, false

color_map = {
	Red: "#CC0000",
	Brown: "#964B00",
	Green: "#266A2E",
	Purple:"#8C489F"
}

controls = [
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
	{"color":"Purple", "text":"Purple"},
	{"color":"Brown", "text":"Brown"},
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
	{"color":"Purple", "text":"Purple"},
	{"color":"Brown", "text":"Brown"},
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
	{"color":"Purple", "text":"Purple"},
	{"color":"Brown", "text":"Brown"},
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
	{"color":"Brown", "text":"Brown"},
	{"color":"Purple", "text":"Purple"},
	{"color":"Green", "text":"Green"},
	{"color":"Red", "text":"Red"},
]


combinations = [
	{"color":"Purple", "text":"Brown"},
	{"color":"Brown", "text":"Red"},
	{"color":"Red", "text":"Purple"},
	{"color":"Green", "text":"Purple"},
	{"color":"Brown", "text":"Red"},
	{"color":"Purple", "text":"Green"},
	{"color":"Brown", "text":"Red"},
	{"color":"Purple", "text":"Brown"},
	{"color":"Red", "text":"Green"},
	{"color":"Purple", "text":"Brown"},
	{"color":"Green", "text":"Purple"}
	{"color":"Brown", "text":"Red"},
	{"color":"Purple", "text":"Green"},
	{"color":"Red", "text":"Purple"},
	{"color":"Brown", "text":"Red"},
	{"color":"Purple", "text":"Brown"},
	{"color":"Green", "text":"Purple"},
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

	if !control_over
		word = controls[question_num].text
		color = controls[question_num].color
	else if control_over
		color = combinations[question_num - controls.length].color
		word = combinations[question_num - controls.length].text

	$(".phase-transition").hide()
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
						num:question_num
					})
					test_logic(true)
				else
					$(this).remove()

test_logic = (spla) ->
	if control_over
		the_obj = combinations
		display_num = question_num - controls.length
	else
		the_obj = controls
		display_num = question_num

	if spla
		splash(display_num, the_obj)

	if not control_over
		$(".btn-start").one 'click', ->
			$(this).remove()
			$(".btn-next").removeClass("hidden")
			unsplash()

	if not started
		$(".btn-start").one 'click', ->
			started = true
			$(this).remove()
			$(".btn-next").removeClass("hidden")
			unsplash()

	else if display_num < the_obj.length
		$(".btn-next").one 'click', ->
			unsplash()
	else
		if the_obj is combinations
			finished()
		else
			if display_num > controls.length-1
				switch_up()

splash = (display_num, the_obj) ->
	$(".test-container").hide()
	$(".splash-screen").removeClass("hidden")
	$(".progress-text").text(display_num + "/" + the_obj.length)
	$(".bar").css("width",  (display_num/the_obj.length)*100 + "%")

phase = (ph) ->
	if control_over
		$(".btn-next").removeClass("hidden")

	$(".test-container").hide()
	$(".phase-transition").show()
	$(".splash-screen").addClass("hidden")
	$(".instructions").replaceWith("<div class='instructions'>"+color_instructions+"</div>")
	$(".phase-notice").text("Test Phase " + ph)

	test_logic(false)

switch_up = () ->
	$(".control").remove()
	$(".interference").removeClass("hidden")
	$(".no-interference").remove()
	control_over = true
	phase(2)

unsplash = () ->
	$(".test-container").show()
	$('.splash-screen').addClass("hidden")
	next_test(!control_over)

finished = () ->
	id = window.location.pathname.split('/')[2]
	$('form').get(0).setAttribute('action', "/test/"+id+"/submit-data")
	$("form").append($("<input>", {type: "hidden", name: "test_data"}).val(JSON.stringify(all_data))).submit()

phase(1)

