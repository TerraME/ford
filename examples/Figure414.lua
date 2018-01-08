import ("ford")

-- Figure 4.14
sessionInfo().graphics = false

env = Environment{
	MonoLake4{},
	MonoLake4{dropExport = true},
}

sessionInfo().graphics = true

chart = Chart{
	target = env,
	select = "waterInLake"
}

env:add(Event{start = 1990, action = chart})

env:run()

