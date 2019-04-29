class Game
require_remote './experiment.rb'
require_remote './schedule.rb'
require_remote './material.rb'


attr_accessor :status, :page
attr_reader :game_status, :game_status_memo, :material, :message, :mainview_status,
  :experiment, :schedule, :place_now, :places_for_menu, :health

  def initialize
    @status = :title
    @game_status = nil
    @game_status_memo = nil
    @mainview_status = nil
    @menu_status = nil
    @message = ["", "", ""]
    @health = 30
    
    @material = Material.new
    @experiment = Experiment.new
    @schedule = Schedule.new

    @experiment.set_veritas(@material.material_atoms)

    @place_now = :home
    @places_for_menu = make_places_menu

    @page = 0
  end

  def start
    @status = :game
  end

  def click_menu(pos)
    @message.clear
    case(pos)
    when 0 #実験
      @game_status = :experiment
      @mainview_status = :set_materials
      @message[0] = "どの素材で実験しよう？"
    when 1 #外出
      @game_status = :go_out
      @mainview_status = :go_out
      @message[0] = "どこに行こう？"
    when 2 #ノート
      if @experiment.note.size == 0
        @message[0] = "まだ一回も実験していない！"
        return 
      end
      @game_status = :note
      @mainview_status = :note
      @page = @experiment.note.size-1
    when 3 #論文
      @game_status = :paper
    when 4 #素材
      @game_status = :material
      @mainview_status = :materials_view
    when 5 #休む
      @mainview_status = :rest
      @game_status = :rest
    when 6 #ヘルプ
      @game_status = :help
    end
  end

  def click_material(pos)
    @experiment.set_material(@material.have_array[pos+@page*16][0], :m)
    @mainview_status = :set_materials

  end

  def click_reagent(pos)
    @experiment.set_material(pos, :r)
    @mainview_status = :set_materials
  end

  def set_material(pos, kind)
    p "set_material"
    @experiment.setting_material = pos[0]
    @page = 0
    if pos[1] == 0
      @mainview_status = :materials_view
    elsif pos[1] == 1
      @mainview_status = :reagents_view
    end
  end

  def start_experiment
    if @experiment.verify != 0
      @message[0] = @experiment.verify
      return
    end
    2.times{|i|@material.have_materials[@experiment.material[i]] -= 1 if @experiment.material[i].class == Symbol}
    @experiment.make_reagent
    @experiment.mes_experiment(@message)
    @mainview_status = :experiment_result
    @schedule.gain_time(1)
  end

  def call_reagent_note(no)
    return if no.class != Number
    @page = @experiment.note.find_index{|n|n[2] == no}
  end

  def click_material_page
    @page = 1 - @page
  end

  def go_out(place) #placeはシンボルで入ってくる
    p "go_out",place

    @message[1] = "go_out " + PLACES[place].to_s
    time = 0

    if place == :home
      @mainview_status = :none
      @game_status = :none 
      time = PLACES[@place_now][1]
    elsif @place_now == :home
      time = PLACES[place][1]
    elsif place == @place_now
      @message[1] = "既にそこにいる"
      return
    end

    @schedule.gain_time(time)
    @health -= time
    @place_now = place
    make_places_menu(@place_now)

  end

  def rest(time)
    time = (time+1)*4
    @message[0] = time.to_s + "時間寝た"
    @health += time*2
    @health = 30 if @health > 30
    @schedule.gain_time(time)
  end

  def go_title
    @status = :title
  end

  def stats
    @status = :stats
  end

  def make_places_menu(except=nil) #ハッシュではなく配列を作る
    p "make_places_menu"
    if gathering_place?(@place_now) 
      @places_for_menu = [[:home,"家に帰る",0,false]]
      return
    end
    places = PLACES.clone
    places.delete_if do |k,v|
      @place_now != :home && gathering_place?(k)
    end
    @places_for_menu = places.map{|k,v|[k,v].flatten}
  end

  def gathering_place?(place)
    place == :forest || place == :mountain || place == :swamp
  end

end