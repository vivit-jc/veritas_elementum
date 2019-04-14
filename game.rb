class Game
require_remote './experiment.rb'


attr_accessor :status
attr_reader :game_status, :game_status_memo, :material_atoms, :materials_know, :page, :message, :mainview_status,
  :experiment

  def initialize
    @status = :title
    @game_status = nil
    @game_status_memo = nil
    @mainview_status = nil
    @menu_status = nil
    @message = ["", "", ""]
    #元素の設定
    atoms = ATOMS.clone
    @material_atoms = []
    @material_atoms += atoms + atoms
    6.times do
      @material_atoms.push atoms.sample
    end
    @material_atoms.shuffle!

    @materials_know = Array.new(30)
    @experiment = Experiment.new
    @experiment.set_veritas(@material_atoms)
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
    when 2 #ノート
      @game_status = :note
    when 3 #論文
      @game_status = :paper
    when 4 #素材
      @game_status = :material
    when 5 #休む
      @game_status = :rest
    when 6 #ヘルプ
      @game_status = :help
    end
  end

  def click_material(pos)
    @experiment.set_material(pos, :m)
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
    @experiment.make_reagent
    @experiment.mes_experiment(@message)
    @mainview_status = :experiment_result
  end

  def click_material_page
    @page = 1 - @page
  end

  def go_out(s)
    @message[1] = "go_out" + s.to_s
  end


  def go_title
    @status = :title
  end

  def stats
    @status = :stats
  end

end