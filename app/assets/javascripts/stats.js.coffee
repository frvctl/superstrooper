#= require d3.v2.js

id = window.location.pathname.split('/')[2]

get_data = () ->
	if id
		$.get '/participants/' + id + '/data', (data) ->
			console.log(data)
			chart(data)
	else
		$.get '/data', (data) ->
			chart(data)

get_data()

chart = (values) ->
	formatCount = d3.format(",.0f")

	margin = {top: 10, right: 30, bottom: 30, left: 30}
	width = 960 - margin.left - margin.right
	height = 500 - margin.top - margin.bottom

	x = d3.scale.linear()
		.domain([0, 4000])
		.range([0, width])

	real_tests = d3.merge(values.map((e) -> return e.tests))

	parts = [real_tests.filter((t) ->
		return t.text_color == "black"
	).map((e) -> return e.response_time),
	real_tests.filter((t) ->
		return t.text_color != "black"
	).map((e) -> return e.response_time)]

	hist = parts.map((e) ->
		return d3.layout.histogram()
			.bins(x.ticks(40))(e))


	ymax = d3.max(hist.map((e) ->
		return d3.max(e, (d) ->return d.y)
	))

	y = d3.scale.linear()
		.domain([0, ymax])
		.range([height, 0]);

	xAxis = d3.svg.axis()
		.scale(x)
		.orient("bottom");

	svg = d3.select("#bar").append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
		.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	colors = ["steelblue", "green"]

	histogram = svg.selectAll(".histogram")
		.data(hist)
		.enter().append("g")
			.attr("fill", (d, i) ->  return colors[i] )
			.attr("class", "histogram")

	line = d3.svg.line()
		.x((d, i) -> return x(d[0]); )
		.y((d, i)  -> return y(d[1]); );

	norm_max = d3.max(parts, (d) ->
		mean = d3.mean(d)
		stdev = Math.sqrt(d3.mean(Math.pow(e - mean, 2) for e in d))
		max = 1 / (Math.sqrt(2 * Math.PI) * stdev)
		return max
	)

	curve = svg.selectAll(".fit")
			.data(parts)
		.enter().append("g")
			.attr("class", "fit")
			.attr "stroke", (d, i) -> return colors[i]

	curve.append('svg:path')
		.attr "d", (d) ->
			return line d3.range(0, 4000, 10).map (x) ->
				mean = d3.mean(d)
				stdev = Math.sqrt(d3.mean(Math.pow(e - mean, 2) for e in d))
				pct_mean = ((1 / ( stdev * Math.sqrt( 2 * Math.PI ))) * Math.exp( - Math.pow(x - mean, 2) / (2 * stdev * stdev))) / norm_max
				return [x, pct_mean * ymax]


	bar = histogram.selectAll(".bar")
			.data((d) -> d )
		.enter().append("g")
			.attr("class", "bar")
			.attr("transform", (d) -> return "translate(" + x(d.x) + "," + y(d.y) + ")" )

	bar.append("rect")
		.attr("x", 1)
		.attr("width", x(hist[0][0].dx) - 1)
		.attr("height", (d) -> return height - y(d.y) )

	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + height + ")")
		.call(xAxis)
