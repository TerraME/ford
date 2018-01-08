import ("ford")

-- Figure 4.15
sessionInfo().graphics = false

env = Environment{
	MonoLake4{export = 0},
	MonoLake4{export = 20},
	MonoLake4{export = 40},
	MonoLake4{export = 60},
	MonoLake4{export = 80},
	MonoLake4{export = 100}
}

sessionInfo().graphics = true

chart = Chart{
	target = env,
	select = "waterInLake2"
}

env:add(Event{start = 1990, action = chart})

env:run()

