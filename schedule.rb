class Schedule

attr_accessor :hour, :day

  def initialize
  	@hour = 8
  	@day = 0

  end

  def gain_time(x)
	@hour += x
	if @hour > 24  	
	  @hour -= 24
	  @day += 1 
	end
  end

  def weekday
  	["花","鳥","風","月"][@day%4]
  end

  def season
  	["春","夏","秋","冬"][@day/16]
  end

  def month_day
  	@day%16
  end

  

end