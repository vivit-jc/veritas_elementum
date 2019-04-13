class View

  def initialize(game,controller)
    @game = game
    @controller = controller

    @clock = Image.new(MAIN_MENU_WIDTH, CLOCK_HEIGHT)
    @clock.box(3, 3, MAIN_MENU_WIDTH-4, CLOCK_HEIGHT-4, WHITE)
    @iconback = Image.new(64,64)
    @iconback.box_fill(0,0,64,64,WHITE)
  end

  def draw
    draw_xy
    draw_debug
    case @game.status
    when :title
      draw_title
    when :game
      draw_game
    when :stats
      draw_stats
    end
  end

  def draw_title
    Window.draw(0,0,Image[:title])
    Window.draw_font(30, 240, "VERITAS, ELEMENTUM", Font50, {color: YELLOW})
    
    TITLE_MENU_TEXT.each_with_index do |menu,i|
      fonthash = {color: YELLOW}
      fonthash = {color: GREEN} if(@controller.pos_title_menu == i)
      Window.draw_font(TITLE_MENU_X,TITLE_MENU_Y[i],menu,Font32,fonthash) 
    end
  end

  def draw_game
    draw_main_menu
    draw_schedule
    draw_message(@game.message)
    case @game.game_status
    when :experiment
      draw_experiment
    end

  end

  def draw_experiment
    case(@game.mainview_status)
    when :set_materials
      draw_set_materials
    when :materials_view
      draw_materials_view 
    when :experiment_result
      draw_experiment_result
    end

  end

  def draw_materials_view
    page = @game.page
    3.times do |i|
      5.times do |j|
        Window.draw(20+80*j,20+110*i,@iconback)
        Window.draw(20+80*j,20+110*i,Image[MATERIALS[j+i*5+page*15]])
        Window.draw_font(20+80*j, 20+110*i+65, MATERIALS[j+i*5+page*15].to_s, Font16) 
        Window.draw_font(20+80*j, 20+110*i+85, atom_j(@game.material_atoms[j+i*5+page*15]), Font16) 
      end
    end
    Window.draw(420,140,Image[:right]) if page == 0
    Window.draw(420,140,Image[:left]) if page == 1
  end

  def draw_set_materials
    2.times do |i|
      Window.draw(EXPERIMENT[i][0], EXPERIMENT[i][1], @iconback)
      if @game.experiment.material[i].class == Symbol
        Window.draw(EXPERIMENT[i][0], EXPERIMENT[i][1], Image[@game.experiment.material[i]]) 
      elsif @game.experiment.material[i].class == Number

      end
    end
    fonthash = {color: WHITE}
    fonthash = {color: GREEN} if(@controller.pos_start_experiment?)
    Window.draw_font(170, 222, "反応させる", Font20, fonthash)
  end

  def draw_experiment_result
    note = @game.experiment.note
    Window.draw_font(30, 50, "実験#"+(note.size).to_s, Font20) 
    2.times do |i|
      Window.draw(30+140*i,90,@iconback)
      Window.draw(30+140*i,90,Image[note.last[i]])
      Window.draw_font(30+140*i, 160, note.last[i], Font20)
    end
    Window.draw_font(30, 200, "魔力変化 " + (note.last[3][0] ? "有" : "無") + "　　魔力量 " + note.last[3][1].to_s, Font20) 
    Window.draw_font(30, 300, note.last.to_s, Font20)

    fonthash = {color: WHITE}
    fonthash = {color: GREEN} if(@controller.pos_one_more_experiment?)
    Window.draw_font(30, 250, "続けて実験を行う", Font20, fonthash)
  end

  def draw_main_menu
    MAIN_MENU_TEXT.each_with_index do |menu,i|
      fonthash = {color: WHITE}
      fonthash = {color: GREEN} if(@controller.pos_main_menu == i)
      Window.draw_font(640 - MAIN_MENU_WIDTH + 30, MENU_EACH_HEIGHT*i+5, menu, Font20, fonthash) 
    end
  end

  def draw_schedule
    Window.draw_font(480, 220, "春 1日(花) 8:00", Font20, {color: WHITE})
    Window.draw(640-MAIN_MENU_WIDTH, 480-SCHEDULE_HEIGHT, @clock)
  end

  def draw_message(str_array)
    str_array.each_with_index do |text, i|
      Window.draw_font(10, 480-MESSAGE_BOX_HEIGHT+i*22, text, Font20) 
    end
  end

  def draw_xy
    Window.draw_font(0,0,Input.mouse_pos_x.to_s+" "+Input.mouse_pos_y.to_s,Font16)
  end

  def draw_debug
    Window.draw_font(0,20,@game.experiment.reagents.to_s,Font16)
  
  end

  def atom_j(atoms)
    atom = atoms.to_s.split("")
    str = []
    atom.each do |a|
      case(a)
      when "f"
        str << "火"
      when "e"
        str << "土"
      when "w"
        str << "風"
      when "a"
        str << "水"
      when "l"
        str << "陽"
      when "d"
        str << "陰"
      end
    end  
    return str[0]+"-"+str[1]
  end

end