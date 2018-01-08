import ("sci")

-- Table 4.1 - in Ford's book
local surfaceAreaEst = Spline{
	points = DataFrame{
		x = {0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000},
		y = {0, 24.7, 35.3, 48.6, 54.3, 57.2, 61.6, 66.0, 69.8}
	}
}

-- Table 4.1 - in Ford's book
local elevationEst = Spline{
    points = DataFrame{
    	x = {0,    1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000},
		y = {6224, 6335, 6369, 6392, 6412, 6430, 6447, 6463, 6477}
    }
}

MonoLake3 = Model{
	waterInLake = 2228,
	finalTime = 2090,
	otherIn = 17 + 20 + 9 + 1.6, -- 47.6,
	otherOut = 1.3 + 13 + 12 + 7.3, -- 33.6,
    evaporationRate = 3.75,
	export = 100,
	precipitationRate = 0.667, 
	sierraGaugedRunoff = 150,
	elevation = function(self)
		return elevationEst:value(self.waterInLake)
	end,
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
		self.chart1 = Chart{target = self, select = "waterInLake"}
		self.chart2 = Chart{target = self, select = "elevation"}
		self.chart3 = Chart{target = self, select = "surfaceArea"}

		self.timer = Timer{
			Event{start = 1990, action = self.chart1},
			Event{start = 1990, action = self.chart2},
			Event{start = 1990, action = self.chart3},
			Event{start = 1991, action = self}
		}
	end
}

