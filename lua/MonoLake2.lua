import ("sci")

-- Table 4.1 - in Ford's book
local surfaceAreaEst = Spline{
	points = DataFrame{
		x = {0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000},
		y = {0, 24.7, 35.3, 48.6, 54.3, 57.2, 61.6, 66.0, 69.8}
	}
}

MonoLake2 = Model{
	waterInLake = 2228,
	finalTime = 2090,
	otherIn = 47.6,
	otherOut = 33.6,
    evaporationRate = 3.75,
	export = 100,
	precipitationRate = 0.667, 
	sierraGaugedRunoff = 150,
	surfaceArea = function(self)
		return surfaceAreaEst:value(self.waterInLake)
	end,
	evaporation = function(self)
		return self:surfaceArea() * self.evaporationRate
	end,
	precipitation = function(self)
		return self:surfaceArea() * self.precipitationRate
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
			select = {"evaporation", "surfaceArea"}
		}

		self.timer = Timer{
			Event{start = 1990, action = self.chart1},
			Event{start = 1990, action = self.chart2},
			Event{start = 1991, action = self}
		}
	end
}

