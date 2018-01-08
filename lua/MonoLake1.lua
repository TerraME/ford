
MonoLake1 = Model{
	waterInLake = 2228,
	finalTime = 2030,
	otherIn = 47.6,
	otherOut = 33.6,
    evaporationRate = 3.75,
	export = 100,
	precipitationRate = 0.667, 
	sierraGaugedRunoff = 150,
	surfaceArea = 39,
	evaporation = function(self)
		return self.surfaceArea * self.evaporationRate
	end,
	precipitation = function(self)
		return self.surfaceArea * self.precipitationRate
	end,
	flowPastDiversionPoints = function(self)
		return self.sierraGaugedRunoff - self.export
	end,
	execute = function(self)
		self.waterInLake = self.waterInLake
			+ self:flowPastDiversionPoints()
			+ self.otherIn
			+ self:precipitation()
			- self.otherOut
			- self:evaporation()

		if self.waterInLake <= 0 then
			self.waterInLake = 0
		end
	end,
	init = function(self)
		self.chart1 = Chart{
			target = self,
			select = {"waterInLake"}
		}

		self.chart2 = Chart{
			target = self,
			select = {"evaporation", "flowPastDiversionPoints"}
		}

		self.timer = Timer{
			Event{start = 1990, action = self.chart1},
			Event{start = 1990, action = self.chart2},
			Event{start = 1991, action = self}
		}
	end
}

